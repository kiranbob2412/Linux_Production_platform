#!/bin/bash
echo "=========================================="
echo " PACKAGE MANAGEMENT"
echo "=========================================="
echo
if command -v apt >/dev/null 2>&1;
then
echo "Package Manager:APT"
echo
echo "Installed Packages:"
dpkg-query -w -f='$
{binary:package}\n' 2>/dev/null |wc -l
echo "Available Updates:"
apt list --upgradable 2>/dev/null | head -20
elif command -v dnf >/dev/null 2>&1;
then
echo "Package Manager: DNF"
dnf check-update 2>/dev/null | head -20 || true
else
echo "No supported package manager found"
fi
