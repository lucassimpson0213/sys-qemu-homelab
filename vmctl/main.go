package main


import (
	"fmt"
	"os/exec"
	"libvirt.org/go/libvirt"

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

	cmd := exec.Command(app)
	stdout, err := cmd.Output()

	if err != nil {
		fmt.Println(err.Error())
		return
	}

	// Print the output
	fmt.Println(string(stdout))
}
