## MiniCloud Learning Plan

Goal: Understand machine lifecycle and basic cloud infrastructure by scripting VM creation.

---

### Phase 1 — Boot a Cloud Image
- [ ] Download Ubuntu cloud image
- [ ] Convert it to `qcow2`
- [ ] Create cloud-init `user-data` with your SSH key
- [ ] Boot the VM with QEMU
- [ ] Successfully SSH into the machine

---

### Phase 2 — Automate Instance Creation
- [ ] Write `vm-new` (clone qcow2 from base image)
- [ ] Write `vm-run` (start the VM with networking)
- [ ] Write `vm-ssh` (connect without thinking about ports)

---

### Phase 3 — Prove It’s a “Cloud”
- [ ] Launch 3 VMs at the same time
- [ ] SSH into each one
- [ ] Install something (e.g., `nginx`) on one VM
- [ ] Shut down one VM
- [ ] Delete its disk
- [ ] Recreate it from the base image
- [ ] Verify it comes back as a fresh machine

---

### Phase 4 — Stress the Concept
- [ ] Break a VM intentionally
- [ ] Destroy it
- [ ] Recreate it in under 30 seconds

**Key realization:**  
A server is not a device — it is a disposable process created from an image.

---

### Phase 5 — Next Step
After this works smoothly:

- Move to **libvirt / virt-manager**
- Then optionally **Proxmox**
- Then optionally **Terraform**

You’ll now understand what those tools are actually automating.

