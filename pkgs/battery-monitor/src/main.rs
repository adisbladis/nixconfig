extern crate battery;
extern crate humantime;
extern crate libnotify;

use std::io;
use std::thread;
use std::time::Duration;
use humantime::format_duration;

// Start warning at percentage
const PCT_MIN: i8 = 20;

// Check interval
const INTERVAL: u64 = 30;

fn check(battery: &battery::Battery, pct_warned: i8) -> i8 {
    let bat_pct = battery.state_of_charge().get::<battery::units::ratio::percent>().round() as i8;

    if battery.state() != battery::State::Discharging || bat_pct > PCT_MIN {
        return 100;
    }

    if bat_pct == pct_warned {
        return pct_warned;
    }

    let sec_to_empty = (match battery.time_to_empty() {
        None => f32::NAN,
        Some(duration) => duration.get::<battery::units::time::second>(),
    }).round() as u64;

    let duration_m = format!("Duration {}", format_duration(Duration::new(sec_to_empty, 0)).to_string());
    let n = libnotify::Notification::new(&format!("Battery at {:?}%", bat_pct),
                                         Some(duration_m.as_str()),
                                         None);
    n.show().unwrap();

    return bat_pct;
}

fn main() -> battery::Result<()> {

    let manager = battery::Manager::new()?;
    let mut battery = match manager.batteries()?.next() {
        Some(Ok(battery)) => battery,
        Some(Err(e)) => {
            eprintln!("Unable to access battery information");
            return Err(e);
        }
        None => {
            eprintln!("Unable to find any batteries");
            return Err(io::Error::from(io::ErrorKind::NotFound).into());
        }
    };

    libnotify::init("battery-monitor").unwrap();

    let mut pct_warned: i8 = 100;
    loop {
        // Don't warn again for a given percentage
        pct_warned = check(&battery, pct_warned);

        thread::sleep(Duration::from_secs(INTERVAL));

        manager.refresh(&mut battery)?;
    }

}
