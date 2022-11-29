---
hostname: pilvi

network:
  dev: eth0

  public:
    net: 46.4.95.160/27
    addr: 46.4.95.174
    mask: 255.255.255.224
    gw: 46.4.95.161

  int:
    net: 192.168.1.16/28
    addr: 192.168.1.2
    mask: 255.255.255.0
    bcast: 192.168.1.255

  virt:
    net: 192.168.1.128/25

  remote_addresses:
  - port: gre1
    addr: 46.4.71.238 # savu
