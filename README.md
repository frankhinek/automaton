# automaton
Human readable automation instructions designed to predictably manage the configuration of macOS and Linux systems

## Usage

Use the following command to create a new encrypted string with Ansible vault:

```bash
ansible-vault encrypt_string --vault-id @prompt 'secret' --name 'var_name'
```

## To Do

1. Create a custom Homebrew formula to install the Automounter Helper.
