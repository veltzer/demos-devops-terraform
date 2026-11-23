#!/bin/bash -e

TF_VAR_pgp_key=$({ gpg --export "rockholla-di" || true; } | base64)
export TF_VAR_pgp_key
terraform init
terraform "$@"
