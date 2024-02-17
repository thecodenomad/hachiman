#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
# You should have this in every custom script, to ensure that your completed
# builds actually ran successfully without any errors!
set -oue pipefail

# Ref: https://bugzilla.redhat.com/show_bug.cgi?id=2264317
rpm-ostree install --enablerepo=updates-testing power-profiles-daemon

