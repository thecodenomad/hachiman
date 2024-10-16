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

| Opinion                  | Minimum         | Preferred                     | Current Status |
| ------------------------ | --------------- | ----------------------------- | -------------- |
| VPN                      | OpenVPN         | OpenVPN, ProtonVPN, Tailscale | Done           |
| User Config Management   | chezmoi         | -                             | Partial        |
| System Config Management | bluebuild files | -                             | Done           |
| Default GUI Apps         | flatpak         | -                             | Done           |
| Dev environments         | distrobox       | -                             | Done           |

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

# Building

## Generate the Recipe

This is used to generate the goodies provided by the recipe.

`bluebuild generate -d ./recipes/recipe.yml`

## Build Locally

`bluebuild build ./recipes/recipe.yml`

## Switch to this OCI Image

`bluebuild rebase ./recipes/recipe.yml`

## Installation

> **Warning** > [This is an experimental feature](https://www.fedoraproject.org/wiki/Changes/OstreeNativeContainerStable), try at your own discretion.

To rebase an existing atomic Fedora installation to the latest build:

-   First rebase to the unsigned image, to get the proper signing keys and policies installed:
    ```
    rpm-ostree rebase ostree-unverified-registry:ghcr.io/blue-build/template:latest
    ```
-   Reboot to complete the rebase:
    ```
    systemctl reboot
    ```
-   Then rebase to the signed image, like so:
    ```
    rpm-ostree rebase ostree-image-signed:docker://ghcr.io/blue-build/template:latest
    ```
-   Reboot again to complete the installation
    ```
    systemctl reboot
    ```

The `latest` tag will automatically point to the latest build. That build will still always use the Fedora version specified in `recipe.yml`, so you won't get accidentally updated to the next major version.

## Workspaces

Hachiman has a few scripts that help maintain a users development workspaces. The goal is to
quickly get a development environment up on a fresh install with little effort. Chezmoi is used
to retrieve dotfiles, within those dot files should be a yaml configuration file that points
to workspaces that should be created. See the system workspaces as an example.

# Next Up

TODOs:

-   Create roles for the following:
    -   Server role - Installs the basics for setting up a homelab server
    -   Developer role - Installs the basics for my preferred development environment regardless of DE.
-   Move non-global configuration files to chezmoi
-   Dev environment in base system, or integrated with distrobox
-   Github Runner
    -   setup to upload container images to local docker repo
    -   setup to upload current ISO and shas to local SMB backup
-   Continued organization
    -   recipes/common/rpm-ostree/<DE>-base.yml - Applications/utilities that should be added/removed for a given DE
