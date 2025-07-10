#!/bin/bash

# Variables for easier configuration
TABLE_NAME="filter"
CHAIN_NAME="output"
PROTO_NAME="inet"

GID_TO_RESTRICT="1001"
WHITELIST_IPS="192.168.1.100,192.168.1.101"

# Flush existing rules
nft flush chain inet $TABLE_NAME $CHAIN_NAME 

# Create the output chain
nft add table inet $TABLE_NAME
nft add chain inet $TABLE_NAME $CHAIN_NAME { type filter hook output priority 0 \; }

# Create the whitelist IP set
nft add set inet $TABLE_NAME whitelist_ips { type ipv4_addr \; }
nft add element inet $TABLE_NAME whitelist_ips { $WHITELIST_IPS }

# Allow the whitelist ids for the group
nft add rule inet $TABLE_NAME $CHAIN_NAME ip daddr @whitelist_ips meta skgid $GID_TO_RESTRICT accept

# Block any other connections for that gid
nft add rule inet $TABLE_NAME $CHAIN_NAME meta skgid $GID_TO_RESTRICT drop

# Allow any other connections
nft add rule inet $TABLE_NAME $CHAIN_NAME accept

# To check the config:
# nft list ruleset
# nft list table inet $TABLE_NAME
