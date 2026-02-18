package main

import (
	"fmt"
	libvert "libvirt.org/go/libvirt"
	"os/exec"
)

func main() {
	fmt.Println("Hello")
	get_vms()
}

func get_vms() {
	app := "virsh"

	// arg0 := "list"
	// arg1 := "--all"
	// arg2 := "\n\tfrom"
	// arg3 := "golang"
	libvert.GetVersion()
	cmd := exec.Command(app)
	stdout, err := cmd.Output()

	if err != nil {
		fmt.Println(err.Error())
		return
	}

	// Print the output
	fmt.Println(string(stdout))
}
