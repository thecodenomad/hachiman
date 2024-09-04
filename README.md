# Hachiman

I set out to build a flavor of Silverblue meant for an AMD-based (7840U) Framework Laptop based on the BlueBuild project.
This includes my preferred GNOME settings, and default apps. The few base binaries are in
`recipes/common/rpm-ostree/rpm-ostree.yml`.

Disclaimer: There are plenty of rough edges around this, so if you choose to install do so via the ISO and don't
blame me if your cat catches fire or if your partner runs away with a delivery person.

## Bluebuild Recipe Descriptions

`recipes/common/rpm-ostree/rpm-ostree.yml` - Contains all cli binaries installed regardless of DE. This should work
regardless of any established roles.

`recipes/roles/laptop-user.yml` - This is my main user, everything I need to setup a new laptop with my preferences.

## Project Opinions

| Opinion | Minimum | Preferred | Current Status |
| --- | --- | --- | --- |
| VPN | OpenVPN | OpenVPN, ProtonVPN, Tailscale | Done |
| User Config Management | chezmoi | - | Partial |
| System Config Management | bluebuild files | - | Done |
| Default GUI Apps | flatpak | - | Done |
| Dev environments | distrobox | - | Done |

## Opinionated Distrobox Configuration

Go and Rust libraries can get unwieldy, so local dev environments will use dedicated home directories to
to keep libraries from cluttering the home folder.

The distrobox home folders follow this convention:
`home=${HACHIMAN_DISTROBOX_HOME}/<distrobox name>-home`

The Hachiman `global` distrobox ini file is found at:
`files/system/usr/share/hachiman/distrobox/distrobox.ini`

This setup currently requires 2 environment variables that can be overridden in .bashrc, etc or
if this repo is forked, can be modified in `files/system/etc/profile.d/hachiman.sh`:

`HACHIMAN_DISTROBOX_INI`
`HACHIMAN_DISTROBOX_HOME`

## Next Up

TODOs:
- Create roles for the following:
  - Server role - Installs the basics for setting up a homelab server
  - Developer role - Installs the basics for my preferred development environment regardless of DE.
- Move non-global configuration files to chezmoi
- Dev environment in base system, or integrated with distrobox
- Github Runner
  - setup to upload container images to local docker repo
  - setup to upload current ISO and shas to local SMB backup
- Continued organization
  - recipes/common/rpm-ostree/<DE>-base.yml - Applications/utilities that should be added/removed for a given DE
