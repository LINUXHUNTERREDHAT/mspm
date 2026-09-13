# mspm

A simple, lightweight package manager.

---

## Usage

### 1. Synchronize Repositories

Fetch and update local repository trees defined in `/etc/mspm/repos.conf`:

```
# mspm sync
```

### 2. Installing Packages

Install one or multiple packages:

```
# mspm install <package1> <package2> ...
```

Explicitly target a specific repository using `pkg::repo` syntax:

```
# mspm install cmake-bin::mspm-repo-master fastfetch
```

### 3. Removing Packages

Remove installed packages from the system:

```
# mspm remove <package1> <package2> ...
```

Target a specific repository entry for removal:

```
# mspm remove fastfetch::mspm-repo-master
```
### 4. Upgrading installed packages: 

```
# mspm update
```

---

## Configuration

* `/etc/mspm/repos.conf` — Defines repositories and sync commands.
* `/etc/mspm/make.conf` — Configures environment variables (e.g., `MAKEOPTS="-j$(nproc)"`).
* `/etc/mspm/installed` — Plain-text database tracking installed package specifications.

### make.conf example

`
CFLAGS="-march=alderlake -O2 -pipe"
CXXFLAGS="-march=alderlake -O2 -pipe"
MAKEFLAGS="${MAKEFLAGS} -j12"
`

---

## Adding custom repositories to `mspm`

To make repositories available to `mspm`, add an entry to `/etc/mspm/repos.conf` using the format `<repo_name> = <sync_command>`

# Creating a Repository for mspm

A guide on how to structure, create, and maintain your own package repository for **mspm**.

---

## Repository Structure

An `mspm` repository is a simple directory hierarchy. Each package lives in its own subdirectory and must contain a build script named `mspm-build`.

```
my-repo/
├── fastfetch/
│   └── mspm-build
├── htop/
│   └── mspm-build
└── cmake-bin/
    └── mspm-build
```

---

## Requirements for `mspm-build`

By default, mspm-build executes inside /etc/mspm/cache/<package_name>. Do not change this working directory; perform all build operations directly within it.

Every `mspm-build` script is sourced as a Bash script and must adhere to the following rules:

### 1. File Naming
* The recipe file **must** be named exactly `mspm-build`.

### 2. Dependencies (`depends`)
* Dependencies are defined using a standard Bash array: `depends=("pkg1" "pkg2::repo")`. Use `depends=("pkg1||pkg2")` to require one of pkgs
* If there are no dependencies, leave the array empty or omit it entirely.

### 3. Version
* The version is used for checking for the updates you should define the version in your mspm-build

### 4. The `install()` Function
* Must be defined in the script.
* Handles downloading, compiling, and copying binaries/files into the system (`/usr`, `/etc`, etc.).

### 5. The `remove()` Function
* Must be defined in the script.
* Cleanly removes all files installed by the package.

---

## Example `mspm-build` Script

```
# Package recipe for fastfetch

#!/bin/sh

version="2.68.1"
depends=("cmake-bin||cmake")

install() {
    if [ ! -f 2.68.1.tar.gz ]; then
        wget https://github.com/fastfetch-cli/fastfetch/archive/refs/tags/2.68.1.tar.gz
    fi
    mkdir -p fastfetch/
    tar -xf 2.68.1.tar.gz -C fastfetch --strip-components=1
    cd fastfetch/
    ./run.sh
    cp build/fastfetch /usr/bin/fastfetch
}

remove() {
    rm -f /usr/bin/fastfetch
}

```
