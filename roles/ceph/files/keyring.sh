#!/bin/bash
# Ceph monitor keyring helper script, doing..
#  1. Generate an administrator keyring
#  2. Generate a bootstrap-osd keyring
#  3. Create keyring for the cluster and add the generated keys to `ceph.mon.keyring`

# Generate an administrator keyring
ceph-authtool --create-keyring /etc/ceph/ceph.client.admin.keyring \
    --gen-key -n client.admin \
    --cap mon 'allow *' \
    --cap osd 'allow *' \
    --cap mds 'allow *' \
    --cap mgr 'allow *'

# Generate a bootstrap-osd keyring
ceph-authtool --create-keyring /var/lib/ceph/bootstrap-osd/ceph.keyring \
    --gen-key -n client.bootstrap-osd \
    --cap mon 'profile bootstrap-osd' \
    --cap mgr 'allow r'

# Create keyring for the cluster and add the generated keys to `ceph.mon.keyring`
ceph-authtool --create-keyring /etc/ceph/ceph.mon.keyring \
    --gen-key -n mon. \
    --cap mon 'allow *'
ceph-authtool /etc/ceph/ceph.mon.keyring --import-keyring /etc/ceph/ceph.client.admin.keyring
ceph-authtool /tmp/ceph.mon.keyring --import-keyring /var/lib/ceph/bootstrap-osd/ceph.keyring
chown ceph:ceph /etc/ceph/ceph.mon.keyring
