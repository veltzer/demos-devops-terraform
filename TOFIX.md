# TOFIX

Findings from a code scan on 2026-10-04.

## High

- `scripts-teaching/tests/test.sh:16` - `find . -print0 -name errored | xargs rm`: `-print0` comes before `-name`, so find prints every path under `tests/`, and `xargs` without `-0` then tries to `rm` all of them (Dockerfile, scripts, workspaces) instead of only the `errored` markers. Use `find . -name errored -delete`.

## Medium

- `scripts-teaching/tests/exercises.sh:17` - copies `../../exercises/${exercise_number}` and special-cases exercise numbers `03` and `11` (lines 31-33), but exercises now live under `exercises/basic/NN_name` (e.g. `exercises/basic/03_plans_and_applies`), so the copy fails for every exercise. Update the path mapping.
- `scripts-teaching/tests/Dockerfile:7-9` - installs `python`, `python-dev` and `py-pip` on `alpine:3.20`, which no longer has Python 2 packages under those names, and then `pip install --user` into the system Python, which PEP 668 blocks. The test image cannot build. Use `python3`/`py3-pip` (or the `aws-cli` apk package) instead.
- `exercises/basic/01_first_terraform_project/main.tf:7` - the `version` argument inside `provider "aws"` blocks (39 .tf files outside `to_intergrate/`, all `~> 2.0`) has been deprecated since Terraform 0.13 and pins the AWS provider to the 2019-era 2.x line, with no comment saying why. Move the constraint to `terraform { required_providers { aws = { source = "hashicorp/aws" } } }` and let `.terraform.lock.hcl` hold the version.
- `examples/experiment-01-intermediate/main.tf:25` - uses `data "template_file"` from the archived `hashicorp/template` provider (no builds for newer platforms such as darwin_arm64); same in `exercises/basic/11_app_in_aws/microservice/main.tf:71`. Use the built-in `templatefile()` function. (`exercises/intermediate/06/template-provider/main.tf:15` teaches the provider itself and should at least say it is deprecated.)
- `rsconstruct.toml:27-70` - the repo has 184 `.tf` files but no processor checks them; `terraform fmt -check` currently reports 82 unformatted files and 3 that do not parse. Add a terraform fmt (and, where feasible, validate) check and fix the files it reports.

## Low

- `to_intergrate/exercises/7.1/microservice/outputs.tf:6` - the `url` output string opens with `"` and closes with `'`, so the file does not parse. Fix the quote. (The two `to_intergrate/exercises/04a/**/main.tf:9` parse failures are deliberate "add trailing quote" student placeholders.)
- `to_intergrate` - the directory name is misspelled ("intergrate") and its ~100 files duplicate older versions of `exercises/basic/*`; finish integrating it and delete it, or rename it to `to_integrate`.
- `scripts-teaching/print-users.sh:9` - when the required argument is missing the script prints the usage message but does not exit, then prints every student's credentials without the region line. Add `exit 1`.
