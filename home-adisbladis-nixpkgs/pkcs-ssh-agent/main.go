package main // import "github.com/adisbladis/pkcs-ssh-agent"

import (
	"context"
	"flag"
	"fmt"
	udev "github.com/jochenvg/go-udev"
	"os"
	"os/exec"
)

// TokenVendor - ...
const subSystem = "usb"
const devType = "usb_device"

func filterDevice(d *udev.Device, tokenVendor string) bool {
	props := d.Properties()
	if props["ID_VENDOR_ID"] != tokenVendor {
		return false
	}

	return true
}

func getInitialActiveDevice(u *udev.Udev, tokenVendor string) (string, error) {
	e := u.NewEnumerate()
	err := e.AddMatchSubsystem(subSystem)
	if err != nil {
		return "", err
	}

	devices, err := e.Devices()
	if err != nil {
		return "", err
	}

	var matches []*udev.Device
	for _, d := range devices {
		if filterDevice(d, tokenVendor) {
			matches = append(matches, d)
		}
	}

	switch len(matches) {
	case 0:
		return "", nil
	case 1:
		return matches[0].Syspath(), nil
	default:
		return "", fmt.Errorf("Can only handle one token at a time")
	}
}

func agentAdd(pkcsSO string) {
	cmd := exec.Command("ssh-add", "-s", pkcsSO, "-c")
	err := cmd.Run()
	if err != nil {
		fmt.Println(err)
	}
}

func agentRemove(pkcsSO string) {
	cmd := exec.Command("ssh-add", "-e", pkcsSO)
	err := cmd.Run()
	if err != nil {
		fmt.Println(err)
	}
}

func main() {
	var pkcsSO = flag.String("pkcs11-so", "", "Shared library to add creds from")
	var tokenVendor = flag.String("token-vendor", "1050", "Token vendor USB device ID (default Yubico)")
	flag.Parse()

	if *pkcsSO == "" {
		fmt.Fprintf(os.Stderr, "Usage of %s:\n", os.Args[0])
		flag.PrintDefaults()
		os.Exit(1)
	}

	u := udev.Udev{}
	activeDevice, err := getInitialActiveDevice(&u, *tokenVendor)
	if err != nil {
		panic(err)
	}
	if activeDevice != "" {
		agentAdd(*pkcsSO)
	}

	// State management loop
	m := u.NewMonitorFromNetlink("udev")
	err = m.FilterAddMatchSubsystemDevtype(subSystem, devType)
	if err != nil {
		panic(err)
	}

	ctx := context.Background()
	ch, err := m.DeviceChan(ctx)
	if err != nil {
		panic(err)
	}

	for d := range ch {
		switch d.Action() {

		case "bind":
			if !filterDevice(d, *tokenVendor) {
				continue
			}
			activeDevice = d.Syspath()
			fmt.Println("Plugged device:", activeDevice)
			agentAdd(*pkcsSO)

		case "remove":
			if activeDevice == d.Syspath() {
				fmt.Println("Unplugged device:", activeDevice)
				activeDevice = ""
				agentRemove(*pkcsSO)
			}
		}

	}

}
