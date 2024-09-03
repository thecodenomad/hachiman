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
