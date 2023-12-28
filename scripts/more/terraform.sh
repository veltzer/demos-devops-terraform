#!/bin/bash -e

TF_VAR_pgp_key=$(gpg --export "Dave Wade-Stein" | base64)
export TF_VAR_pgp_key
terraform init
terraform "$@"
