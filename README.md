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

---

## Configuration

* `/etc/mspm/repos.conf` — Defines repositories and sync commands.
* `/etc/mspm/make.conf` — Configures environment variables (e.g., `MAKEOPTS="-j$(nproc)"`).
* `/etc/mspm/installed` — Plain-text database tracking installed package specifications.

---

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

Every `mspm-build` script is sourced as a Bash script and must adhere to the following rules:

### 1. File Naming
* The recipe file **must** be named exactly `mspm-build`.

### 2. Dependencies (`depends`)
* Dependencies are defined using a standard Bash array: `depends=("pkg1" "pkg2::repo")`.
* If there are no dependencies, leave the array empty or omit it entirely.

### 3. The `install()` Function
* Must be defined in the script.
* Handles downloading, compiling, and copying binaries/files into the system (`/usr`, `/etc`, etc.).

### 4. The `remove()` Function
* Must be defined in the script.
* Cleanly removes all files installed by the package.

---

## Example `mspm-build` Script

```
# Package recipe for fastfetch

#!/bin/sh

depends=("cmake-bin")

install() {
    if [ ! -f 2.68.1.tar.gz ]; then
        wget https://github.com/fastfetch-cli/fastfetch/archive/refs/tags/2.68.1.tar.gz
    fi
    tar -xf 2.68.1.tar.gz
    cd fastfetch-2.68.1/
    ./run.sh
    cp build/fastfetch /usr/bin/fastfetch
}

remove() {
    rm -f /usr/bin/fastfetch
}

```

---

## Adding Your Repository to `mspm`

To make your repository available to `mspm`, add an entry to `/etc/mspm/repos.conf` using the format `<repo_name> = <sync_command>`
