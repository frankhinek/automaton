# automaton
Human readable automation instructions designed to predictably manage the
configuration of macOS and Linux systems

## Usage

Although the vast majority of the tasks normally associated with setting up a
new system have been automated, there are still a few steps that require
manual procedures after the Ansible run.

## Installation

### Dependencies

First, make sure you have all those things installed:

- git: to clone the repo
- curl: to download files

### Install

Then, run these steps:

```console
$ git clone https://github.com/frankhinek/automaton ~/Code/automaton
$ cd ~/Code/automaton
$ git submodule update --init --recursive
$ ./run
```

### Update

To update, you just need to `git pull` and run the bootstrap script again:

```console
$ cd ~/Code/automaton
$ git pull origin master
$ ./run
```

### PGP Keys

Automaton includes support for using PGP keys to sign git commits.  If you wish
to sign your commits, then follow the steps below.

Start by ensuring that `enable_git_signing` is set to `true` in the `all`
group variables.

Next, generate new `git_signing_key` variable values for the `personal` and
`work` group variables.  Use the following command to create a new encrypted string with Ansible vault:

```bash
$ ansible-vault encrypt_string --vault-id @prompt 'secret' --name 'git_signing_key'
```

For daily use, especially on a mobile device such as a MacBook or Linux laptop,
a strong security measure is to remove the master secret key from the keyring.
You will often hear people refer to this as a _laptop keyring_.  You can then
use the signing subkey to sign git commits, etc.  There are multiple ways to
accomplish this.  Two options are detailed below.

#### Option 1

1. Import your public and private key pair to the new machine:
```bash
$ gpg --import my_gpg_private_key.asc
$ gpg --import my_gpg_public_key.asc
```
1. Ensure that the Key ID printed is the correct one, and if so, then go ahead and add ultimate trust for it:
```bash
$ gpg --edit-key <KEY_ID>
...
Command>
```
1. At the `Command>` prompt, type in `trust`.
1. You will be prompted to decide how far to trust this key.  Since, presumably, this is your key that you have verified you would enter `5` and answer `y` to confirm.
1. Export the secret subkeys to file:
```bash
$ gpg --export-secret-subkeys --armor --output secret-subkeys.asc <KEY_ID>
```
1. Delete all the secret keys of your key from the keyring.  This includes the
master key and all subkeys.
```bash
$ gpg --delete-secret-keys <KEY_ID>
```
1. Version 2 of GnuPG will prompt you to confirm the deletion of the secret key
of the master key and each subkey.  You should respond `y` when prompted to
delete the secret key and then confirm by entering `y` again.
1. When prompted to delete the first subkey, enter `n`.  This will result in
an error message which indicates that the secret master key was deleted, but the
subkeys were *not* deleted.

#### Option 2

1. From a trusted machine that already contains your key in its keyring, export
only the subkeys:
```bash
$ gpg --export-secret-subkeys --armor --output secret-subkeys.asc <KEY_ID>
```
1. Export the public keys:
```bash
$ gpg --export --armor --output public-keys.asc <KEY_ID>
```
1. Import the public keys into the keyring:
```bash
$ gpg --import public-keys.asc
```
1. Import the secret subkeys, without the master secret key, into the daily
use keyring:
```bash
$ gpg --import secret-subkeys.asc
```

#### Verify the Daily-use Keyring

Regardless of which approach you took, the output from the `gpg -K` command
should display the master key with a hash character (e.g., `sec#`) indicating
that the secret master key is missing as we intended.

## To Do

- [x] Create a custom Homebrew formula to install the Automounter Helper.

## Thanks

Rather than forking an existing Ansible macOS or Linux setup repository I
started from a blank canvas and added only what I needed.  However, nearly every
bit of this was copied directly from or heavily based on work by the individuals
listed below. Thanks to all that shared their code!

- [caarlos0/dotfiles.fish](https://github.com/caarlos0/dotfiles.fish)
- [caarlos0/machine](https://github.com/caarlos0/machine)