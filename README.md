# Hachiman

I set out to build a flavor of Silverblue meant for an AMD-based (7840U) Framework Laptop based on the BlueBuild project.
This includes my preferred GNOME settings, and default apps. The few base binaries are in
`recipes/common/rpm-ostree/rpm-ostree.yml`.

Disclaimer: There are plenty of rough edges around this, so if you choose to install do so via the ISO and don't
blame me if your cat catches fire or if your partner runs away with a delivery person.

I'm a sucker for distro hopping, and it becomes annoying to have to setup everything over and over again to get
to my preferred development box. Sure, I could use a VM, but I want to see how distros work on my main work machine
(my Framework laptop). The intention of Hachiman is to go from no-OS to development of personal/work projects, on any computer,
as quickly as possible without loads of additional dependencies or infrastructure (ansible, etc).

Silverblue + yafti + Chezmoi fits the need pretty solidly as I can create an installable ISO very easily thanks
to [Bluebuild](https://blue-build.org/) and [Universal Blue](https://universal-blue.org/) infrastructure (you guys rock!!)

# Oddities

Yep, I know some of this is weird. I'm experimenting, and likely these opinions will change drastically.

## Opinionated Distrobox Configuration

Go and Rust libraries can get unwieldy, so local dev environments will use dedicated home directories to
to keep libraries from cluttering the home folder. This may change depending on level of pain. The idea is to have
one folder that can deleted safely knowing it will be recreated by whatever project is being worked on.

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

## Makefile

Or just use the makefile, though ymmv.

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

Just tweaks and fixes, nothing big left atm.
