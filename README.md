```
# mspm

A simple, lightweight, source-based package manager designed for **NoPersonalLife Linux**.

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
# mspm install <package1> [<package2> ...]
```

Explicitly target a specific repository using `pkg::repo` syntax:

```
# mspm install cmake-bin::mspm-repo-master fastfetch
```

### 3. Removing Packages

Remove installed packages from the system:

```
# mspm remove <package1> [<package2> ...]
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

```
