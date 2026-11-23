#!/bin/bash -e
# This script is meant to be run in the User Data of each EC2 Instance while it's booting. It starts a simple
# "Hello, World" web server that acts like a backend service that returns JSON.

# Send the log output from this script to user-data.log, syslog, and the console
# From: https://alestic.com/2010/12/ec2-user-data-output/
exec > >({ tee /var/log/user-data.log || true; } | logger -t user-data -s 2>/dev/console || true) 2>&1

# Terraform renders this file as a template and fills in the quoted values below.
# Everything after this point reads them as ordinary bash variables, so a literal
# ${name} is written $${name} (Terraform's escape), which lets shellcheck see where
# each variable comes from.
readonly server_text="${server_text}"
readonly server_http_port="${server_http_port}"

echo "{\"text\": \"$${server_text}\"}" > index.html
nohup busybox httpd -f -p "$${server_http_port}" &
