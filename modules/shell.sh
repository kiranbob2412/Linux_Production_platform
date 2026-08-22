#!/bin/bash
echo "=========================================="
echo "SHELL AUTOMATION"
echo "=========================================="
echo
echo "Bash Version:"
bash --version | head -1
echo
echo "Shell:"
echo "$SHELL"
echo
echo "Current User:"
whoami
echo
echo "Script PID:"
echo "$$"
echo
echo "Required Commands:"
for command in bash grep sek awk find tar ssh curl; do
if command -v "$command" >/dev/null 2>&1; then
echo "OK $command"
else
echo "MISS $command"
fi
done
