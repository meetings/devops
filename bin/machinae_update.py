#!/usr/bin/env python
# -*- coding: utf-8 -*-
# machinae_update.py, 2015-01-20 / Meetin.gs

from pprint import pprint
from os import environ
from sys import argv
from json import load
from urllib import urlencode
from httplib import HTTPSConnection

Usage = """machinae.py, 2015-01-20 / Meetin.gs

Required environment variables:
 PROVIDED_SERVICES     path to provided_services.config
 GAPIER_SECRET         machinae spreadsheet access token

Optional, used only if set:
 SSH_CONFIG_PREPENDIX  file used to prepend generated ssh_config(5)
 SSH_CONFIG_APPENDIX   file used to append generated ssh_config(5)
 MACHINAE_LIST         generated flat list of machinae
 ANSIBLE_LIST          generated list in Ansible inventory format
"""

Report_found = """Found:
{:>4} entries in provided_services and
{:>4} entries from spreadsheet.
"""

Report_parsed = """Parsed:
{:>4} dom0s and
{:>4} domUs with proper configuration.
"""

Report_incomplete = """Incompletely matched hosts:
 {}
"""

Report_dom0less = """DomUs without dom0:
 {}
"""

SSH_config_dom0 = """Host {0}
\tPort 11122
\tHostName {0}.dicole.com
"""

SSH_config_domU = """Host {0}
\tPort {1}
\tHostName {2}.dicole.com
"""

MACH_list = """{:7} {:20} {}\n"""

Ansible_domU = """{:20} ansible_ssh_host={:18} ansible_ssh_port={}\n"""

Ansible_dom0 = """
[{0}]
{0:20} ansible_ssh_host={0}.dicole.com   ansible_ssh_port=11122
"""

def read_services():
    L = []

    with open(environ['PROVIDED_SERVICES']) as File:
        for line in File:
            if line == "\n":
                continue
            if line[0] == "#":
                continue

            words = line.split()
            gwonly = True if 'gwonly' in words else False

            if 'userlogin' in words:
                L.append({'name': words[2], 'port': words[0], 'gwonly': gwonly})

    return L


def machinae_fetch():
    head = {
        "Accept": "*/*",
        "Content-Type": "application/x-www-form-urlencoded"}

    body = urlencode({
        "worksheet_token": "machinae:" + environ['GAPIER_SECRET']})

    connection = HTTPSConnection("meetings-gapier.appspot.com")
    connection.request("POST", "/fetch", body, head)

    return load(connection.getresponse())


def read_all_the_file(var):
    if var in environ:
        with open(environ[var]) as Input:
            return Input.read()
    else:
        return ''


def machinae_in_services(m, services):
    for s in services:
        if m['hostname'] == s['name']:
            return True
    return False


def _filter_and_combine(machinae, services):
    i = dict(machinae.items() + services.items())
    i['name'] = i.pop('hostname')
    i['gw'] = 'gateway' if i['gwonly'] else i['dom0']
    return { key: i[key] for key in ['name', 'port', 'dom0', 'gw'] }


def filter_and_combine(machinae, services):
    dom0s = []
    domUs = []
    notfound = []

    for m in machinae:
        found = False

        if m['hostname'] == m['dom0']:
            dom0s.append(m['hostname'])
            continue

        for s in services:
            if m['hostname'] == s['name']:
                found = True
                domUs.append(_filter_and_combine(m, s))

        if not found:
            notfound.append(m['hostname'])

    return (dom0s, domUs, notfound)


def write_ssh_config(dom0s, domUs):
    with open(environ['HOME'] + '/.ssh/config', 'w') as File:
        File.write(read_all_the_file('SSH_CONFIG_PREPENDIX'))

        for i in dom0s:
            File.write(SSH_config_dom0.format(i))

        for i in domUs:
            # FIXME Should check that i['gw'] really exists
            File.write(SSH_config_domU.format(i['name'], i['port'], i['gw']))

        File.write(read_all_the_file('SSH_CONFIG_APPENDIX'))


def write_machinae_list(dom0s, domUs):
    dom0less = []

    with open(environ['MACHINAE_LIST'], 'w') as File:
        for i in domUs:
            if i['dom0'] in dom0s:
                File.write(MACH_list.format(i['port'], i['name'], i['dom0']))
            else:
                dom0less.append(i['name'])

    return dom0less


def write_ansible_hosts(dom0s, domUs):
    with open(environ['ANSIBLE_LIST'], 'w') as File:
        for i in dom0s:
            File.write(Ansible_dom0.format(i))
            for x in domUs:
                if x['dom0'] == i:
                    File.write(Ansible_domU.format(
                        x['name'], x['gw'] + ".dicole.com", x['port']))


def main():
    if '-h' in argv or '--help' in argv:
        print Usage
        return

    if 'PROVIDED_SERVICES' not in environ or 'GAPIER_SECRET' not in environ:
        print Usage
        return

    services = read_services()
    machinae = machinae_fetch()

    print Report_found.format(len(services), len(machinae))

    dom0s, domUs, notfound = filter_and_combine(machinae, services)

    print Report_parsed.format(len(dom0s), len(domUs))
    print Report_incomplete.format(" ".join(sorted(notfound)))

    write_ssh_config(dom0s, domUs)

    if 'MACHINAE_LIST' in environ:
        dom0less = write_machinae_list(dom0s, domUs)
        if dom0less:
            print Report_dom0less.format(" ".join(sorted(dom0less)))

    if 'ANSIBLE_LIST' in environ:
        write_ansible_hosts(dom0s, domUs)


if __name__ == "__main__":
    main()
