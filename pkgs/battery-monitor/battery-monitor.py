#!/usr/bin/env python
from datetime import timedelta
from notifypy import Notify
from typing import Set
import psutil
import math
import time


# Don't warn again for a given percentage
pct_warned: int = 100


# Start warning at percentage
pct_min: int = 20


interval = 30


def check():
    global pct_warned

    bat = psutil.sensors_battery()

    pct = math.floor(bat.percent)

    if bat.power_plugged or pct > pct_min:
        pct_warned = 100
        return

    if pct == pct_warned:
        return

    pct_warned = pct

    n = Notify()
    n.title = f"Battery at {pct}%"
    n.icon = ""

    secsleft = bat.secsleft
    if secsleft == psutil.POWER_TIME_UNKNOWN:
        n.message = ""
    else:
        n.message = "Duration {}".format(timedelta(seconds=secsleft))

    n.send()


def main():
    while True:
        time.sleep(interval)
        check()


if __name__ == "__main__":
    main()
