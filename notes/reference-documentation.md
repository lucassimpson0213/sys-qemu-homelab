Core libvirt learning docs (read in this order)

libvirt Getting Started Guide
https://libvirt.org/guide.html

What it teaches: the architecture (daemon, domains, networks, storage).
→ This is the one that makes Cockpit finally make sense.

libvirt Network configuration (NAT, bridges, virbr0)
https://libvirt.org/formatnetwork.html

What it teaches: why your installer hung, how DHCP + NAT + virtual router work.

virsh command manual
https://libvirt.org/manpages/virsh.html

What it teaches: the “ground truth” CLI you’ll rely on instead of guessing from a UI.

virt-install manual (Debian manpage)
https://manpages.debian.org/virt-install

What it teaches: how automated VM installs actually work — this is basically the backend of your future vmctl tool.

(Optional but very useful later)

libvirt storage pools/volumes overview
https://libvirt.org/storage.html

What it teaches: where VM disks live and how cloning VMs actually works.
