#!/bin/bash
PROJECT_ROOT="$(cd "$(dirname "$ {BASH_SOURCE[0]}")/.." && pwd)"
echo "=========================================="
echo " PERMISSON AUDIT"
echo "=========================================="
echo
echo "Project Permissions:"
find "$PROJECT_ROOT" -maxdepth 2 -printf "%M %u:%g %P\n" 2>/dev/null | head -40
echo
echo "World_Writable Files:"
find "$PROJECT_ROOT" -type f -perm -0002 -print 2>/dev/null
echo
echo "Executable Scripts:"
find "$PROJECT_ROOT" -type f -name "*.sh" -perm -0100 -print
