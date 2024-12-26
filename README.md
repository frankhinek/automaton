# automaton

Human readable automation instructions designed to predictably manage the configuration of macOS and Linux systems

## First Run

### Host Name

Change my primary MacBook's host name using the terminal:

```shell
sudo scutil --set HostName wintermute
sudo scutil --set LocalHostName wintermute
sudo scutil --set ComputerName wintermute
```

Reboot for changes to take full effect.

### macOS Prerequisites

Ensure that all required dependencies are installed:

- `git`: to clone the repo
- `curl`: to download files
- `homebrew`: to install packages

If `git` or `curl` are missing, install Xcode Command Line Tools:

```shell
xcode-select --install
```

If `brew` is missing, install Homebrew:

```shell
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

To ensure that the Terminal app has full disk access on macOS, follow these steps:

1. Click on the **** menu icon in the top-left corner of your screen.
2. Select **System Settings** from the menu.
3. In the System Preferences window, click on **Privacy & Security**.
4. Click on **Full Disk Access**.
5. Locate the **Terminal** app and click the **lock icon** if it is not already enabled. You will be prompted to enter your password.
6. Close the Terminal application and reopen it to ensure that the changes take effect.

### Linux Prerequisites

Install `git` and `curl` using your package manager.

### Install nix

There are multiple ways to install Nix.  This guide uses Determinate System’s shell installer, which is a one-liner as described in their [GitHub repository](https://github.com/DeterminateSystems/nix-installer):

```shell
curl \
  --proto '=https' \
  --tlsv1.2 \
  -sSf \
  -L https://install.determinate.systems/nix \
  | sh -s -- install
```

The installation takes a minute or two. After running the command, the installer asks for your sudo password and then prints an explanation about what it will do to the system.

It’s advisable to check if there have been any errors during the installation and if there are none, _close_ the shell and start a new one. We don’t need to restart the system.

To test if Nix is working, run the GNU hello package:

```shell
$ nix run "nixpkgs#hello"
Hello, world!
```

### Bootstrap Nix

The general idea is that we want to have one configuration that sets our system up as we want it.  Bootstrapping this new configuration can be done by cloning the repo and running a single command:

```shell
git clone https://github.com/frankhinek/automaton ~/automaton
cd ~/automaton
nix develop -c dot-apply
```

## Post first run

### Fish as the default shell

```shell
which fish | sudo tee -a /etc/shells
chsh -s $(which fish)
```

### Authenticate with GitHub CLI Tool

```shell
gh auth login
```

## Usage

### Updating

Run `dot-apply` to rebuild your system configuration and apply the latest changes.

```shell
nix develop -c dot-apply
```

### Syncing Configuration

Execute `dot-sync` to synchronize your configuration with GitHub, update the flake, remove outdated files, and apply the latest changes.

```shell
nix develop -c dot-sync
```

### Cleaning Up

Execute `dot-clean` to remove outdated files.

```shell
nix develop -c dot-clean
```

## Acknowledgements

Thanks to the [caarlos0](https://github.com/caarlos0) for the
[dotfiles](https://github.com/caarlos0/dotfiles) and
[dotfiles.fish](https://github.com/caarlos0/dotfiles.fish) repositories.

## License

[MIT](LICENSE)
