#!/usr/bin/python3

import json
import requests
from re import search
import readline
import sys
import os

class Completer(object):

    def __init__(self, options):
        self.options = sorted(options)

    def complete(self, text, state):
        if state == 0:
            if text:
                self.matches = [s for s in self.options if s and s.startswith(text)]
            else:
                self.matches = self.options[:]

        try:
            return self.matches[state]
        except IndexError:
            return None

def get_csl():
    request = requests.get('https://api.github.com/repos/citation-style-language/styles/git/trees/master?recursive=1')
    data = request.json()
    files = []

    for item in data['tree']:
        if search(".csl", item['path']):
            files.append(item['path'])

    completer = Completer(files)
    readline.set_completer(completer.complete)
    readline.parse_and_bind("tab: complete")
    for item in files:
        readline.add_history(item)
    csl = input("Select one of the .csl format files (Tab to show all): ")

    # Have to use a tempfile since python discards non int return values to stderr and
    # we need this value in the parent bash script
    tmpfile = open("tmp.txt", "w")
    tmpfile.write(csl)
    tmpfile.close()

if __name__ == "__main__":
    try:
        get_csl()
    except KeyboardInterrupt:
        print("\nInterrupted. Exiting.")
        sys.exit(1)
