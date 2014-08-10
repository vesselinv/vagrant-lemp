# A LEMP vagrant machine

## Introduction

This project automates the setup of a LEMP development environment.

## Requirements

* [VirtualBox](https://www.virtualbox.org)

* [Vagrant](http://vagrantup.com)

* [Cygwin](https://www.cygwin.com/) or any other ssh-capable terminal shell for the `vagrant ssh` command

## How To Build The Virtual Machine

Building the virtual machine is this easy:

    host $ git clone https://github.com/vesselinv/vagrant-lemp.git
    host $ cd vagrant-lemp
    host $ vagrant up --provision

If the base box is not present that command fetches it first.

    host $ vagrant ssh
    Welcome to Ubuntu 14.04 LTS ...
    ...
    vagrant@vagrant:~$

Ports 80 and 3306 on guest and forwarded to 8080 and 33306 respectively.

## What's In The Box

* Ubuntu 14.04 x64
* MySQL
* Nginx
* php5-fpm
* phpmyadmin

## Recommended Workflow

The recommended workflow is

* edit files in the host computer

* run within the virtual machine

Your home folder is synced to `/home/vagrant/code` on the guest.

## Database
* For mysql the default user is root: `mysql -u root`

## Tutorial

To see a complete tutorial how to build this machine from scratch, visit [http://vesselinv.com/lemp-with-vagrant/](http://vesselinv.com/lemp-with-vagrant/)

## Virtual Machine Management

When done just log out with and suspend the virtual machine

    host $ vagrant suspend

then, resume to hack again

    host $ vagrant resume

Run

    host $ vagrant halt

to shutdown the virtual machine, and

    host $ vagrant up

to boot it again.

You can find out the state of a virtual machine anytime by invoking

    host $ vagrant status

Finally, to completely wipe the virtual machine from the disk **destroying all its contents**:

    host $ vagrant destroy # DANGER: all is gone

Please check the [Vagrant documentation](http://docs.vagrantup.com/v2/) for more information on Vagrant.
