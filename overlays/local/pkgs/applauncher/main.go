package main // github.com/adisbladis/nixconfig/overlays/local/pkgs/applauncher

import (
	"fmt"
	"github.com/godbus/dbus"
	"github.com/godbus/dbus/introspect"
	"os"
	"os/exec"
)

const intro = `
<node>
	<interface name="com.github.adisbladis.AppLauncher">
		<method name="Start">
			<arg direction="in" type="as"/>
		</method>
	</interface>` + introspect.IntrospectDataString + `</node> `

type service struct{}

func (s service) Start(args []string) *dbus.Error {
	if len(args) == 0 {
		return nil
	}

	go func() {
		cmd := exec.Command(args[0], args[1:]...)
		err := cmd.Start()
		if err != nil {
			fmt.Println(err)
		}
	}()

	return nil
}

func main() {
	conn, err := dbus.SessionBus()
	if err != nil {
		panic(err)
	}
	reply, err := conn.RequestName("com.github.adisbladis.AppLauncher",
		dbus.NameFlagDoNotQueue)
	if err != nil {
		panic(err)
	}
	if reply != dbus.RequestNameReplyPrimaryOwner {
		fmt.Fprintln(os.Stderr, "name already taken")
		os.Exit(1)
	}
	s := service{}
	conn.Export(s, "/com/github/adisbladis/AppLauncher", "com.github.adisbladis.AppLauncher")
	conn.Export(introspect.Introspectable(intro), "/com/github/adisbladis/AppLauncher",
		"org.freedesktop.DBus.Introspectable")
	fmt.Println("Listening on com.github.adisbladis.AppLauncher")
	select {}
}
