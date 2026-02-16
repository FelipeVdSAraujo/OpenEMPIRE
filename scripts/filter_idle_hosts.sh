#!/bin/bash

# Original list of hostnames
hostname="$1"

# Convert to array
IFS='|' read -r -a host_array <<< "$hostname"

# Get list of busy hosts from qstat
busy_hosts=$(qstat -u "*" | awk 'NR>2 {print $8}' | sort | uniq)

# Check if this works, otherwise change line 17 to:
#    if ! echo "$busy_hosts" | grep -q "all.q@$hostname.local"; then 
# Filter out busy hosts
available_hosts=()
for host in "${host_array[@]}"; do
    if ! echo "$busy_hosts" | grep -q "$host"; then
        available_hosts+=("$host")
    fi
done

# Join available hosts back into a string
new_hostname=$(IFS='|'; echo "${available_hosts[*]}")

if [[ -z "$new_hostname" ]]; then
    echo No available nodes
    exit
fi
# Output the result
echo "$new_hostname"
