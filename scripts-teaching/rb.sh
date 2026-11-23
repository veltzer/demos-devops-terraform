#!/bin/bash -e

for bucket in $({ aws s3 ls || true; } | awk '{print $3}')
do
	aws s3 rb --force "s3://${bucket}"
done
