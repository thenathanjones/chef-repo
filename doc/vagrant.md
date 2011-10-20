# Installing CentOS 5.6 64-bit and Puppet on Vagrant

##  Notes

This document is an adaptation of the instructions found here:
<http://vagrantup.com/docs/base_boxes.html>

These instructions are specifically for 64-bit CentOS and Puppet.

Created with the following software:

 * Mac OS X 10.6.8
 * VirtualBox 4.0.10
 * vagrant 0.7.6

### Download install ISO: TODO url

### Create a new VirtualBox machine

Launch VirtualBox.

Click **New**.

The **New Virtual Machine Wizard** launches.

Click **Continue**.

#### VM Name and OS Type

 * **Name:** <kbd>vagrant-centos</kbd>
 * **Operating System:** <kbd><samp>Linux</samp></kbd>
 * **Version:** <kbd><samp>Red Hat (64 bit)</samp></kbd>

Click **Continue**.

#### Memory

 * **Base Memory Size:** <kbd>360 MB</kbd>

Click **Continue**.

#### Virtual Hard Disk

 * Select **Boot Hard Disk**.
 * Select **Create new hard disk**.

Click **Continue**.

The **Create New Virtual Disk Wizard** launches.

Click **Continue**.

#### Hard Disk Storage Type

* Select **Dynamically expanding storage**.

Click **Continue**.

#### Virtual Disk Location and Size

 * **Location:** <kbd>vagrant-centos</kbd>
 * **Size:** <kbd>40.00 GB</kbd>

Click **Continue**.

Finish creation of disk:

Click **Done**.

Finish creation of VM:

Click **Done**.

### Adjust VM settings

Select **vagrant-centos**.

Click **Settings** in the toolbar.

#### Disable Audio

Select **Audio** tab in **Settings** window.

 * Deselect **Enable Audio**.

#### Make sure network is set to NAT

Select **Network** tab in **Settings** window.

 * Select **Adapter 1** tab.
 * Select **Enable Network Adapter**.
 * **Attached to:** <kbd><samp>NAT</samp></kbd>

#### Disable USB

Select **Ports** tab in **Settings** window.

 * Select **USB** tab.
 * Deselect **Enable USB Controller**.

#### Save Settings

Click **OK**.

### Attach install ISO to the VM

Select **vagrant-centos**.

Click **Settings** in the toolbar.

Select **Storage** tab in **Settings** window.

 * Select **Empty** under **IDE Controller**.
 * On the right side of the window, to the right of **CD/DVD Drive: IDE Secondary**, click the CD icon and select **Choose a virtual CD/DVD disk file…**.
 * Navigate to and select `CentOS-5.6-x86_64-bin-DVD-1of2.iso`
 * Click **Open**.
 * Click **OK**.

### Run the VM

Select **vagrant-centos**.

Click **Start** in the toolbar.

### Run through the install procedure

At the <samp>boot:</samp> prompt type:

    linux text

and press <kbd>Enter</kbd>.

Run through the prompts, choosing reasonable defaults. Settings of note:

Initialize the drive and erase all data, choosing the option:

    Remove all partitions on selected drives and create default layout.

When configuring the `eth0` interface:

Select:

    [*] Activate on boot
    [*] Enable IPv4 support

Leave IPv6 disabled.

For the network configuration select:

    (*) Dynamic IP configuration (DHCP)

For the hostname configuration select:

    (*) manually

And set the hostname to: <kbd>vagrant-centos</kbd>

Set the root password to: <kbd>vagrant</kbd>

In the package selection:

Deselect:

    [ ] Desktop - Gnome

Select:

    [*] Customize software selection

In the customized package group selection deselect *everything*, including:

    [ ] Base
    [ ] Dialup Networking Support
    [ ] Editors
    [ ] Text-based Internet

### Finish installation

Remove the disk image:

 * Devices -> CD/DVD Devices -> Remove disk from virtual drive

Reboot the VM.

### Set hostname

    hostname vagrant-centos.vagrantup.com

Edit `/etc/sysconfig/network` to set the `HOSTNAME` line:

    HOSTNAME=vagrant-centos.vagrantup.com

### sshd configuration

Edit `/etc/ssh/sshd_config` to set the `UseDNS` to `no` by adding the line:

    UseDNS no

### Add stuff

Upgrade the kernel:

    yum -y upgrade kernel

Add some useful packages:

    yum -y install curl ftp rsync sudo time wget which vixie-cron man bind-utils traceroute

Add packages needed for building VirtualBox Additions

    yum -y install gcc bzip2 make kernel-devel

### Remove stuff

    yum -y erase wireless-tools gtk2 libX11 hicolor-icon-theme avahi freetype bitstream-vera-fonts

### Reboot

Reboot the virtual machine to boot with the new kernel.

    shutdown -r now

### VirtualBox Additions

Load the guest additions disk:

* Devices -> Install Guest Additions…

Mount the guest additions disk and run the install script:

    mount -o ro -t iso9660 /dev/cdrom /mnt

    sh /mnt/VBoxLinuxAdditions.run

There will be an error about "Installing the Window System drivers". This should be okay(?).

### Create the vagrant user

    useradd vagrant

    groupadd -r admin

    usermod -G admin vagrant

Set the password for the vagrant user to "vagrant":

    passwd vagrant

Set up sudo permissions:

    visudo

Add the following lines at the bottom of the sudoers file:

    ## Allows users in group admin to run all commands without a password
    %admin  ALL=(ALL) NOPASSWD: ALL

Comment out the `Defaults requiretty` line so ssh commands work:

    ## commented out so ssh commands works
    #Defaults requiretty

Additionally comment out the `Defaults !visiblepw` line:

    ## commented out so ssh commands works
    #Defaults !visiblepw

Add the variable `PATH` to the list of variables in the `Defaults env_keep` list.

Otherwise sudo cleans the path and loses ruby. See: <http://stackoverflow.com/questions/257616>

Exit `visudo`.

Add `/usr/sbin` and `/sbin` to the vagrant user's `PATH`:

    echo 'export PATH="$PATH:/usr/sbin:/sbin"' >> ~vagrant/.bashrc

### Change to the vagrant user

Reboot to make sure the guest additions are loaded:

Log in as vagrant.

### Install EPEL, ELFF, IUS

    sudo rpm -Uvh http://download.fedora.redhat.com/pub/epel/5/x86_64/epel-release-5-4.noarch.rpm

    sudo rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL

    sudo rpm -Uvh http://download.elff.bravenet.com/5/x86_64/elff-release-5-3.noarch.rpm

    sudo rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-ELFF

    sudo rpm -Uvh http://dl.iuscommunity.org/pub/ius/stable/Redhat/5/x86_64/ius-release-1.0-6.ius.el5.noarch.rpm

    sudo rpm --import /etc/pki/rpm-gpg/IUS-COMMUNITY-GPG-KEY

### Install ruby gems

    sudo yum -y install ruby ruby-devel rubygems

### Install puppet

    sudo gem install puppet --no-ri --no-rdoc

Optionally, you can specify the version needed:

    sudo gem install puppet --no-ri --no-rdoc --version=2.6.4

### Update everything

    sudo yum -y update

### Add Vagrant's "insecure" public key

    mkdir ~/.ssh

    chmod 700 ~/.ssh

    curl https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub >> ~/.ssh/authorized_keys

    chmod 600 .ssh/authorized_keys

### Fiddle with MAC address

    /sbin/ifconfig

Write down the MAC address of eth0 (eg. 08:00:27:AE:D9:11 ).

### Clean up caches, etc.

    sudo yum clean headers packages dbcache expire-cache

### Shut down the VM

    sudo shutdown -P now

### Export and package

Follow instructions on <http://vagrantup.com/docs/base_boxes.html>
