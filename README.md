# automaton

Human readable automation instructions designed to predictably manage the
configuration of macOS and Linux systems

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

To ensure that the Terminal app has full disk access on macOS, follow these
steps:

1. Click on the **** menu icon in the top-left corner of your screen.
2. Select **System Settings** from the menu.
3. In the System Preferences window, click on **Privacy & Security**.
4. Click on **Full Disk Access**.
5. Click the **+** button to add a new entry.
6. Locate the **Terminal** app under **/Applications/Utilities**.
7. Close and reopen Terminal to ensure that the changes take effect.

### Linux Prerequisites

Install `git` and `curl` using your package manager.

### Install nix

There are multiple ways to install Nix. This guide uses Determinate System’s
shell installer, which is a one-liner as described in their
[GitHub repository](https://github.com/DeterminateSystems/nix-installer):

```shell
curl -fsSL https://install.determinate.systems/nix | sh -s -- install
```

The installation takes a minute or two. After running the command, the installer
asks for your sudo password and then prints an explanation about what it will do
to the system.

It’s advisable to check if there have been any errors during the installation
and if there are none, _close_ the shell and start a new one. We don’t need to
restart the system.

To test if Nix is working, run the GNU hello package:

```shell
$ nix run "nixpkgs#hello"
Hello, world!
```

### Bootstrap Nix

Clone the dotfiles repository:

```shell
git clone https://github.com/frankhinek/automaton ~/.automaton
cd ~/.automaton
```

The [Nix-Darwin](https://github.com/LnL7/nix-darwin) package manager is used to
manage macOS configuration and applications. Since Nix-Darwin isn't installed
yet, we can bootstrap by downloading it temporarily and running it one time so
it can take care of itself afterwards:

```shell
nix run nix-darwin -- switch --flake ~/.automaton
```

After installing and starting a new shell, you can run `just apply` to apply
changes to your system:

```shell
just apply
```

## Post first run

### Authenticate with GitHub CLI Tool

```shell
gh auth login
```

### Configure SteerMouse

[SteerMouse](https://plentycom.jp/en/steermouse/) is a utility that lets you
customize buttons, wheels and cursor speed. It is used to configure the
additional button on an Elecom trackball. Although the app can be installed by
Automaton, there currently is no way to programmatically configure settings.

Some SteerMouse settings can be manually imported:

1. Open the SteerMouse app.
2. Ensure the "HUGE TrackBall" device is selected and has a green status
   indicator.
3. Click the **Edit** button next to the "Default" drop-down menu.
4. In the bottom-left corner, click the button that has a round circle and three
   dots and select **Import**.
5. Select the `modules/darwin/programs/steermouse/Default.smsetting_app` file
   and click **Open**.
6. Click **Ok** to return to the main SteerMouse window and then close the app.

Additional settings must be manually configured:

1. In SteerMouse, click on the **Cursor** tab, set **Acceleration** to `1`, and
   ensure that **Sensitivity** is set to `1600`.
2. Click on thte **Device** tab and change the **Button Count** ttto `8`.
3. Click on the **License & Support** tab, click **Purchase or Enter License**,
   enter the **ID** and **CODE** stored in 1Password, and click **OK**.

You can now close the SteerMouse app.

## Usage

### Updating

Run `just apply` to rebuild your system configuration and apply the latest
changes.

```shell
just apply
```

### Syncing Configuration

Execute `just sync` to synchronize your configuration with GitHub, update the
flake, remove outdated files, and apply the latest changes.

```shell
just sync
```

### Cleaning Up

Execute `just clean` to remove outdated files.

```shell
just clean
```

## Acknowledgements

- Thanks to [caarlos0](https://github.com/caarlos0) for the
  [dotfiles](https://github.com/caarlos0/dotfiles) and
  [dotfiles.fish](https://github.com/caarlos0/dotfiles.fish) projects.
- Thanks to [khaneliman](https://github.com/khaneliman/khanelinix) for the
  [khanelinix](https://github.com/khaneliman/khanelinix) project.
- Thanks to [jakehamilton](https://github.com/jakehamilton) for the
  [config](https://github.com/jakehamilton/config) and
  [Snowfall Lib](https://github.com/snowfallorg/lib) projects.

## License

[MIT](LICENSE)
