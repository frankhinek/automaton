#!/usr/bin/env python3

'''
Custom dynamic inventory script for Ansible, in Python.
'''

import os
import sys
import argparse
import json

import re
import socket

class ExampleInventory(object):

    def __init__(self):
        self.inventory = {}
        self.read_cli_args()

        # Called with `--list`.
        if self.args.list:
            self.inventory = self.example_inventory()
        # Called with `--host [hostname]`.
        elif self.args.host:
            # Not implemented, since we return _meta info `--list`.
            self.inventory = self.empty_inventory()
        # If no groups or vars are present, return empty inventory.
        else:
            self.inventory = self.empty_inventory()

        print(json.dumps(self.inventory));

    # Example inventory for testing.
    def example_inventory(self):
        host = socket.gethostname()

        if re.match(r'frankhinek-macbookpro(?:\.(?:local|lan)?)?\Z', host):
            group = 'work'
        elif re.match(r'frank-mbp(?:\.(?:local|lan)?)?\Z', host):
            group = 'personal'
        elif re.match(r'dev(?:vm)?\d+', host):
            group = 'devservers'
        else:
            group = 'local'

        return {
            group: {
                'hosts': ['localhost'],
                'vars': {
                    'ansible_connection': 'local'
                }
            },
            '_meta': {
                'hostvars': {}
            }
        }

    # Empty inventory for testing.
    def empty_inventory(self):
        return {'_meta': {'hostvars': {}}}

    # Read the command line args passed to the script.
    def read_cli_args(self):
        parser = argparse.ArgumentParser()
        parser.add_argument('--list', action = 'store_true')
        parser.add_argument('--host', action = 'store')
        self.args = parser.parse_args()

# Get the inventory.
ExampleInventory()
