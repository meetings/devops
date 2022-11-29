
# Meetin.gs infrastructure for 2017 and above

<!-- pandoc -c md.css -s infra-2017.md -o infra-2017.html -->

[cloudimage]: https://cloud-images.ubuntu.com/xenial/current/
[zolcrypt]: http://serverfault.com/a/588056
[opencloudblog]: http://www.opencloudblog.com/?p=240


## Ansible

Ansible is used to bootstrap and orchestrate Meetin.gs infrastructure. Please see `README.md` on the top level of this repository for usage.


## User configuration data

FIXME User configuration is in three different places...


## Bootstrap a server

### Overview

Hetzner's dedicated servers (i.e. bare iron servers) are used as low level building blocks for Meetin.gs infrastructure. They are referred to as *virthosts* from now on. Ubuntu Server 16.04 LTS is used on all the virthosts with Libvirt/qemu/KVM as the virtualization platform. Open vSwitch and GRE tunnelling is used to create a virtual overlay network, which allows all the VMs to connect each other.

### Prerequisites

 + Ansible.
 + A dedicated server booted to rescue mode and the root password.

### Steps

Following steps assume an existing infrastructure with an overlay network and a puppetmaster host. If you are bootstrapping the very first virthost, only steps 1 through 5 are applicable. FIXME What after that?

1. Run automated installation. In the following command, replace `name` (in *hostname* extra var) with the *inventory name* of the server or servers.

        $ ansible-playbook hetzner-bootstrap.yml -k -e hostname=name

2. Do manual disk partitioning after the *installimage* has finished.

3. Reboot to the new system. At boot server will upgrade itself and install some required packages. It takes a while, but please, wait for it to finish before proceeding. To monitor the progress, tail the file `/var/log/dpkg.log`.

4. After package installation has finished, create and set up disk encryption and ZFS:

        # # FIXME # Do cryptsetup thing also to write encrypted bits only
        # # FIXME # ZIL setup and things might differ per hardware
        # zpool create z0 mirror /dev/...
        # # FIXME # This is default already... zfs set compression=lz4 z0

5. Do the automated configuration.

        $ ansible-playbook hetzner-configure.yml -k -e hostname=name

6. Reboot again. After reboot the overlay network should be functional.

7. FIXME? Run puppet(8):

        # puppet agent --onetime --no-daemonize --verbose

8. Download the Ubuntu cloud image. See section *Update cloud image cache* for details.


## Update cloud image cache

### Overview

Official Ubuntu Xenial cloud image is used to create new virtual machines. To quickly create a VM, each virthost has a local image cache, which holds the cloud image converted to raw format. A playbook exists to update the image to newest version.

Updating the image is seldom mandatory, but it reduces the bootstrapping time of a new VM, because less packages need to be upgraded on the first boot. It is recommended to update image cache whenever new VMs need to be created.

### Steps to update the cache

1. Go to [cloud image download page][cloudimage] and obtain the SHA1 checksum for the cloud image in QCOW2 format (filename should be `xenial-server-cloudimg-amd64-disk1.img`).

2. In this repository, update variable `cloud_image_sha1` in the file `group_vars/virthosts` to have the latest checksum.

3. Run the update playbook, which downloads the latest cloud image to each host and converts it to raw format:

        $ ansible-playbook update-cloud-image-cache.yml


## Creating virtual machines manually

On a new infrastructure, there is no automated way to create VMs, because at lease one *intranet services host* is needed to set up new VMs (see section *Intranet services host* for details). To solve this chicken or the egg dilemma, a VM must be created manually. Some possible methods are:

- Start with a standard cloud image, but use alternative *cloud-init* source or *libguestfs* to do the initial configuration.
- Create a VM in another environment and migrate it.
- Use *virt-install*.

Details of manual VM creation are out of scope of this documentation. Good luck!


## Intranet services host

### Prerequisites

 + A bootstrapped virthost
 + A manually created virtual machine

### Overview

Intranet services host provides DNS, DHCP, cloud-init source, and package repository services to the virtual machine subnet. These allow e.g. automated provisioning of new virtual machines and using domain names to access services.

Intranet has three virtual partitions: virtual machine hosts, intranet hosts and application virtual machines. For redundancy, there is one intranet host on each virtual machine host (i.e. there is equal number of them). For robustness, both types of hosts have statically assigned addresses. The number of VM hosts is assumed to be relatively small, thus the administration overhead should be light. Application virtual machines receive an address from the intranet hosts via DHCP.

Following address space allocation should allow maximum of 14 virthosts and 126 VMs. It should be noted that the network partitioning is purely virtual and the netmask is always 24 bits i.e. `255.255.255.0`.

<table>
<thead>
<tr>
<td><b>Name</b></td>
<td><b>Network</b></td>
<td><b>First - last address</b></td>
</tr>
</thead>

<tr>
<td>Virthosts</td>
<td>192.168.1.0/28</td>
<td>192.168.1.1 - 192.168.1.14</td>
</tr>

<tr>
<td>Intranet hosts</td>
<td>192.168.1.16/28</td>
<td>192.168.1.17 - 192.168.1.30</td>
</tr>

<tr>
<td>VMs</td>
<td>192.168.1.128/25</td>
<td>192.168.1.129 - 192.168.1.254</td>
</tr>
</table>

### Steps

Following assumes that a virtual machine has been created beforehand and it is called `ns1`.

1. Configure `interfaces`(5) to assign static address to the network interface (here `ens3`):

        auto ens3
        iface ens3 inet static
          address 192.168.1.17
          netmask 255.255.255.0
          broadcast 192.168.1.255
          gateway 192.168.1.1
          dns-nameservers 8.8.8.8 8.8.4.4
          mtu 1462

2. If cloud-init slows down the boot process, use the following to disable it:

        # for S in cloud-init-local.service cloud-final.service cloud-config.service cloud-init.service; do
        >   sudo systemctl disable $S
        > done

3. Create host configuration file `host_vars/ns1`. To create a new DDNS key and secret, use the following command:

        $ dnssec-keygen -a HMAC-MD5 -b 128 -r /dev/urandom -n USER DDNS_UPDATE

4. Run automated configuration:

        $ ansible-playbook net.yml -e vm_name=ns1


## Creating virtual machines

### Overview

Virtual machine provisioning (i.e. creation and destruction) and basic configuration is automated with Ansible. Creation of a new VM goes as follows:

 + A new volume is provisioned from the ZFS pool.
 + Cloud image from local cache is written to the volume.
 + New virtual machine is defined with an XML template and then started.
 + At boot, VM connects to custom cloud-init source.
 + With cloud-init:
    - System is upgraded.
    - Administration critical packages are installed.
    - Admin accounts are created.

The above process was chosen, because writing a raw cloud image to volume is fairly quick way of creating a new virtual machine. Also, standard cloud images are very widely used, supported, and trustworthy starting point.

### Prerequisites

 + A bootstrapped virthost
 + Initialized cloud image cache
 + Intranet services host with a cloud-init source
 + (Optionally) Puppetmaster host

### Steps

Following instructions assume that the host is called `name-1` and configuration files are named after the host.

1. Create a configuration file `env/name-1.yml` with following variables:

    - `vm_name`: Hostname for the new VM.
    - `vm_host`: Inventory name of the virthost (i.e. where the new VM is created).
    - `vm_vcpus`: Number of virtual CPUs.
    - `vm_memory`: Amount of memory available to VM (in MB).
    - `vm_vol_size`: Size of the root volume (in bytes).

    Volume size has minimun size and alignment limitations. All the values which are at least and multiples of `8589934592` should be safe. Experimentation is required for more fine grained volume allocation.

2. Create a Ansible host configuration `host_vars/name-1`. FIXME! Write about host configuration when it stabilizes.

3. Create a new virtual machine as configured.

        $ ansible-playbook create-vm.yml -e @env/name-1.yml

4. Do basic setup for the new VM.

        $ ansible-playbook configure-and-puppetize.yml -e @env/name-1.yml


## Configuration management with Puppet

FIXME


## Log aggregation

FIXME


## Monitoring with Bloonix

FIXME

<!--
Changes:
workers 1
agents 1
timezone Etc/UTC
-->


## Highly available Wordpress

### Overview

To create a scalable and highly available Wordpress cluster, one must handle two types of state information. The first is data in a relational database. It is assumed that a HA DB setup is already available and the subject is not covered here.

Second part of the problem are the Wordpress and plugin files on a filesystem. To have multiple Wordpress installations, they all need to have access to the same directory structure. GlusterFS is a scalable distributed filesystem, which is used to solve that problem.

### Prerequisites

+ Two or more virtual machines
+ On each VM, a dedicated block device / partition

### Steps

1. Provision virtual machines with create an extra partition.

2. Create suitable `host_vars` configurations. FIXME What kind of?

3. Run automated installation.

        $ ansible-playbook wordpress.yml -e wp_hosts=<...>

    Where `wp_hosts` should be the list of inventory names of Wordpress instances.

4. If `/var/log/glusterfs/etc-glusterfs-glusterd.vol.log` gets flooded with messages such as this:

        W [socket.c:588:__socket_rwv] 0-nfs: readv on ... failed (Invalid argument)

    Disable nfs kernel module with the following:

        # gluster volume set vol0 nfs.disable true


## General notes

### ZFS

ZoL does scrubbing automatically (see cron.d for details).

ZoL does not yet support encryption. [The best workaround][zolcrypt] for now is to use LUKS on the disks/partitions and build ZFS on top of them. May affect speed, but shouldn't be bad.

Lack of native encryption support also means that send/recv is not encrypted, but that doesn't matter as data is send over ssh anyways. But it matters with backups (which are not automatically encrypted).

Changing the size of a ZFS volume is really easy. Following example assumes pool `z0`, volume `vol-1`, and new size of 24 gigabytes.

    # zfs set volsize=24G z0/vol-1

After the volume is resized, either create new partitions manually or let cloud-init resize the root filesystem at boot.

### openvswitch

Tunnel port name must not be `gre0` for some reason. Names `greN` are acceptable when `N >= 1`.

GRE/IPSec packets must be marked `1` (default value of `0` means unencrypted connection). For example:

    # iptables -t mangle -A PREROUTING -p esp -j MARK --set-mark 1
    # iptables -t mangle -A PREROUTING -p udp --dport 4500 -j MARK --set-mark 1

Marking is done by `/etc/init.d/openvswitch-ipsec` script, but it may or may not work, when firewall is managed with *ferm*.

Also, the *systemd* unit `openvswitch-nonetwork.service` is broken. See [Open Cloud blog post][opencloudblog] for details.

### Offline migration

When migrating some consideration is needed when the host CPU changes. If the hardware environment is not completely homogeneous, it might be useful to configure VMs to use lowest common denominator processor configuration.

    # virsh dumpxml name-1 --migratable | ssh target.dicole.com "cat > name-1.xml"
    # zfs send z0/name-1@snap | pv -ab | ssh -C target.dicole.com zfs recv z0/name-1

### libguestfs

Mount VM disk to `/mnt` and use root shell to study and modify it:

    $ sudo guestmount -a /dev/zvol/z0/name-1 -i /mnt && sudo -i && sudo guestunmount /mnt
