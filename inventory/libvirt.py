#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# Requires: python-configparser (>= 3.0)
#
# TODO:
#  Override virthosts from env $INVENTORY_VIRTHOSTS

from __future__ import print_function

import re
import json
import subprocess

from sys import exit, stderr
from os import environ, makedirs, path
from configparser import ConfigParser
from argparse import ArgumentParser
from time import time

GROUP_TAG = 'meetings'

VIRTHOSTS_INVENTORY_FILE = 'virthosts'

CACHE_AGE = 3600
CACHE_DIR = '~/.ansible/cache'
CACHE_FILE = 'ansible-libvirt-{}.json'.format(GROUP_TAG)

LIST_CMD = ['virsh', '-c', '', '-q', 'list', '--name']

DOMIFADDR_CMD = [
    'virsh', '-c', '',
    'domifaddr', '--source', 'agent', '--interface', 'ens3'
]

DOMIFADDR_PATTERN = r'^\s(\w+)\s+([0-9a-f:]+)\s+ipv4\s+([0-9\.]+)/\d+'


def _err(msg): print("error: " + msg, file=stderr)
def _warn(msg): print("warning: " + msg, file=stderr)


def get_connstr(virthost):
    return 'qemu+ssh://' + virthost + '/system'


def get_env(name):
    try:
        return environ[name]
    except KeyError as e:
        _warn("environment variable {} is not defined".format(e))
    return ''


def get_virthosts():
    cp = ConfigParser(allow_no_value=True)
    inv_dir = get_env('ANSIBLE_HOSTS')
    virthosts_file = path.join(inv_dir, VIRTHOSTS_INVENTORY_FILE)
    if not path.isfile(virthosts_file):
        _err("not a file: '{}'".format(virthosts_file))
        exit(1)
    cp.read(virthosts_file)
    try:
        return [str(x) for x in cp['virthosts']]
    except KeyError:
        _warn("failed to extract virthosts")
    return []


def get_vms(virthost):
    cmd = LIST_CMD[:]
    cmd[2] = get_connstr(virthost)
    return subprocess.check_output(cmd).splitlines()


def get_ifaddr(virthost, vm):
    cmd = DOMIFADDR_CMD[:]
    cmd[2] = get_connstr(virthost)
    cmd.append(vm)
    stdout = []
    try:
        stdout = subprocess.check_output(cmd).splitlines()
    except subprocess.CalledProcessError:
        _warn("could not get address from {}".format(vm))
    for line in stdout:
        capture = re.match(DOMIFADDR_PATTERN, line)
        if capture:
            return capture.group(3)


def fetch_inventory():
    inventory = {
        GROUP_TAG: {
            'hosts': [],
            'vars': {}
        },
        '_meta': {
            'hostvars': {}
        }
    }

    virthosts = get_virthosts()

    for virthost in virthosts:
        vms = get_vms(virthost)
        for vm in vms:
            addr = get_ifaddr(virthost, vm)
            inventory[GROUP_TAG]['hosts'].append(vm)
            inventory['_meta']['hostvars'][vm] = {'ansible_host': addr}

    inventory[GROUP_TAG]['vars'] = {
        'ansible_ssh_common_args':
            '-o ProxyCommand="ssh {} -W %h:%p"'.format(virthosts[0])
    }

    return inventory


def read_cache(filename):
    data = None
    try:
        modified = path.getmtime(filename)
        if (modified + CACHE_AGE) < time():
            return None
        with open(filename, 'r') as File:
            data = json.load(File, encoding='utf-8')
    except OSError as e:
        pass
    except IOError as e:
        pass
    except ValueError as e:
        pass
    return data


def write_cache(data, filename):
    with open(filename, 'w') as File:
        json.dump(data, File, encoding='utf-8', indent=4, separators=(',', ': '), sort_keys=True)


def main():
    inventory = None

    ap = ArgumentParser(description="Ansible dynamic inventory for libvirt")
    ap.add_argument("-l", "--list", action='store_true', help="standard Ansible parameter")
    ap.add_argument("-f", "--refresh", action='store_true', help="force cache refresh")
    args = ap.parse_args()

    cache_dir = path.expanduser(CACHE_DIR)
    if not path.exists(cache_dir):
        makedirs(cache_dir)
    cache_file = path.join(cache_dir, CACHE_FILE)
    if not args.refresh:
        inventory = read_cache(cache_file)
    if not inventory:
        inventory = fetch_inventory()
        write_cache(inventory, cache_file)

    print(json.dumps(inventory, indent=4, separators=(',', ': '), sort_keys=True))


if __name__ == "__main__":
    main()
