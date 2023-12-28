#!/bin/bash -e
# This script is meant to be run in the User Data of each EC2 Instance while it's booting. It starts a simple
# "Hello, World" web server that acts like a backend service that returns JSON.

# Send the log output from this script to user-data.log, syslog, and the console
# From: https://alestic.com/2010/12/ec2-user-data-output/
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

# The variables below are filled in using Terraform interpolation
# shellcheck disable=SC2154
echo "{\"text\": \"${server_text}\"}" > index.html
# shellcheck disable=SC2154
nohup busybox httpd -f -p "${server_http_port}" &
