#!/bin/bash

IFACES='$$interfaces'
ADDRS='$$addresses'

# backup /etc/network/interfaces
yes no | mv -i /etc/network/interfaces{,.default}

# generate /etc/network/interfaces
echo "auto lo" >> /etc/network/interfaces
echo "iface lo inet loopback" >> /etc/network/interfaces
echo >> /etc/network/interfaces
for i in $(seq 1 $(echo $IFACES | wc -w)); do >> /etc/network/interfaces
  IFACE=$(echo $IFACES | cut -d " " -f $i) >> /etc/network/interfaces
  ADDR=$(echo $ADDRS | cut -d " " -f $i) >> /etc/network/interfaces
  echo "auto $IFACE" >> /etc/network/interfaces
  if [ "$ADDR" = "dhcp" ]; then
  echo "iface $IFACE inet dhcp" >> /etc/network/interfaces
  else
  echo "iface $IFACE inet static" >> /etc/network/interfaces
  echo "address $ADDR" >> /etc/network/interfaces
  fi
  echo >> /etc/network/interfaces
done

# restart network.service
systemctl restart networking
