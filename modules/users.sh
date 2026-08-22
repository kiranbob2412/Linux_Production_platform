#!/bin/bash
echo "=========================================="
echo " USERS & GROUPS"
echo "=========================================="
echo
echo "Current User:"
whoami
echo
echo "User ID:"
id
echo
echo "Groups:"
groups
echo
echo "Logged-in Users:"
who
echo
echo "System Accounts:"
awk -F: '{print $1}' /etc/passwd | head -20
