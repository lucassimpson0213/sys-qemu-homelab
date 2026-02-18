
****<img width="1904" height="984" alt="image" src="https://github.com/user-attachments/assets/6c40bbfc-f66f-407d-9f46-201767b05300" />



<img width="1641" height="1307" alt="image" src="https://github.com/user-attachments/assets/348fd287-8f87-455d-a22d-0fbc6c51a840" />

## Homelab UI / Monitoring Services

- Netdata — real-time system metrics and kernel activity visualization
- Prometheus — collects and stores machine metrics
- Grafana — dashboards and historical graphs
- Portainer — container management web UI


## Unified / Single-Pane Tools

- Netdata Cloud — centralized dashboard aggregating metrics from all Netdata agents/hosts
- Cockpit — web control panel for managing Linux systems (services, logs, terminals, networking)

You can literally do all 4 in one weekend and your homelab instantly turns into a mini cloud environment.
# Home-Cloud

A personal homelab platform that turns a few machines into a small self-hosted cloud.

The goal of this project is to learn real infrastructure by building it — not by using a cloud provider, but by *becoming* one.

This system provisions servers, deploys applications, monitors services, and exposes them over HTTPS inside a private network.

---

## What this is

Home-Cloud is a mini platform-as-a-service running on a Raspberry Pi and virtual machines.

It provides:
- reproducible machines (infrastructure as code)
- one-command application deployment
- internal DNS service discovery
- HTTPS routing to services
- monitoring and alerts
- centralized automation

Instead of manually configuring computers, the entire environment is defined in code and can be rebuilt at any time.

---

## Architecture

Each node has a role:

| Node      | Purpose |
|----------|------|
| gateway  | reverse proxy + HTTPS routing |
| control  | automation + orchestration |
| worker   | runs applications and jobs |
| monitor  | metrics, dashboards, alerts |

Multiple roles may run on the same machine at the beginning.

---

## Core Components

- automation: Ansible playbooks
- routing: reverse proxy (HTTPS)
- service discovery: internal DNS
- monitoring: metrics + dashboards
- deployment: git-based application deploys

---

## What it can do

- bring a fresh machine online automatically
- deploy a service from a git repo
- restart crashed services
- expose apps at `https://service.home`
- monitor CPU, memory, and uptime
- send alerts when something breaks

---

## Why

Modern developers rely on cloud platforms but rarely understand how they actually work.

This project is an attempt to learn:

- Linux system administration
- networking
- distributed systems
- observability
- reliability engineering
- deployment automation

The homelab becomes a controlled environment for experimenting, breaking things, and rebuilding them safely.

---

## Libvert integration

# Libvirt Runner – MiniCloud Control Plane

This document describes how to build a small "cloud-like" runner that provisions and manages virtual machines using **libvirt** (which itself controls QEMU/KVM).

Instead of manually launching `qemu-system-*` commands, your program becomes a **control plane** that talks to libvirt.

You are essentially building a tiny EC2.

---

## What a Libvirt Runner Gives You

Using libvirt instead of raw QEMU provides:

* Persistent VM lifecycle (define, start, stop, destroy)
* Managed networking (NAT bridge + DHCP)
* Managed storage pools and volumes
* Easier SSH access (automatic IP assignment)
* Less QEMU command complexity
* Stable orchestration behavior

Your runner becomes a **machine orchestrator** instead of a process launcher.

---

## Architecture Overview

```
Your Runner  --->  libvirt  --->  QEMU/KVM  --->  Virtual Machines
(Control Plane)    (Manager)    (Hypervisor)    (Instances)
```

Think of the layers like this:

| Layer    | Real Cloud Equivalent |
| -------- | --------------------- |
| Runner   | AWS EC2 Control Plane |
| libvirt  | Hypervisor Manager    |
| QEMU/KVM | Hypervisor            |
| VM       | EC2 Instance          |

---

## Development Levels

### Level 1 — Shell Runner (Recommended Starting Point)

Your program wraps command-line tools:

* `virsh`
* `virt-install`
* `virt-clone`

Pros:

* Fast to build
* Easy to debug
* Teaches infrastructure concepts

Cons:

* CLI parsing is imperfect

---

### Level 2 — API Runner (Real Control Plane)

Use libvirt APIs directly:

* Python (`libvirt-python`)
* Go (`libvirt-go`)

Pros:

* Structured errors
* Cleaner automation
* Production-like behavior

Cons:

* More setup work

---

### Level 3 — Hybrid

Use the API for lifecycle and CLI tools for convenience tasks (like cloud-init ISO generation).

---

## Minimal Runner Workflow

Your runner should perform these steps:

1. Ensure a storage pool exists
2. Create a VM disk (from a base image)
3. Generate a cloud-init seed ISO
4. Define the VM with `virt-install --import`
5. Start the VM
6. Retrieve IP address from DHCP
7. Print SSH command

This is effectively **EC2 instance provisioning**.

---

## Example Commands

### Create a Volume

```bash
sudo virsh vol-create-as default worker1.qcow2 20G --format qcow2
```

(Optional: upload a base image)

```bash
sudo virsh vol-upload --pool default worker1.qcow2 ./images/ubuntu-base.qcow2
```

---

### Create Cloud-Init Seed ISO

```bash
cloud-localds seed-worker1.iso user-data meta-data
```

---

### Create and Import VM (ARM Example)

```bash
sudo virt-install \
  --name worker1 \
  --memory 2048 \
  --vcpus 2 \
  --arch aarch64 \
  --machine virt \
  --import \
  --disk path=/var/lib/libvirt/images/worker1.qcow2,format=qcow2,bus=virtio \
  --disk path=./seed-worker1.iso,device=cdrom \
  --network network=default,model=virtio \
  --osinfo ubuntu22.04 \
  --noautoconsole
```

---

### Start and Stop

```bash
sudo virsh start worker1
sudo virsh shutdown worker1
sudo virsh destroy worker1
```

---

### Get VM IP Address

```bash
sudo virsh net-dhcp-leases default
```

Your runner can parse this output and display:

```
ssh ubuntu@<ip-address>
```

---

## Suggested Programming Languages

| Language | Notes                                |
| -------- | ------------------------------------ |
| Python   | Most common for automation           |
| Go       | Excellent for CLI tools              |
| Rust     | Possible but fewer standard bindings |

Recommended progression:

1. Prototype with shell commands
2. Automate with Python or Go
3. Replace CLI calls with libvirt API

---

## Why This Matters

By building this runner, you learn the real mechanics of cloud computing:

* Disk images
* Machine identity
* Network assignment
* Boot orchestration
* Instance lifecycle

You are not just "running VMs" — you are implementing the same ideas behind AWS EC2, Proxmox, and private cloud platforms.

---

## Conceptual Takeaway

A server is not a device.

A server is:

> A disposabl

