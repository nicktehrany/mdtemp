#!/usr/bin/python

import json
import requests
from re import search
import sys
from prompt_toolkit import prompt
from prompt_toolkit.completion import FuzzyWordCompleter

def get_csl():
    try:
        request = requests.get('https://api.github.com/repos/citation-style-language/styles/git/trees/master?recursive=1')
        request.raise_for_status()
    except requests.exceptions.HTTPError as err:
        raise SystemExit(err)

    data = request.json()
    files = []

    for item in data['tree']:
        if search(".csl", item['path']):
            files.append(item['path'])

    completer = FuzzyWordCompleter(files)
    csl = prompt("Look up one of the .csl format files: ", completer=completer, complete_while_typing=True, complete_in_thread=True)

    # Have to use a tempfile since python discards non int return values to stderr and
    # we need this value in the parent bash script
    tmpfile = open("tmp.txt", "w")
    tmpfile.write(csl)
    tmpfile.close()

if __name__ == "__main__":
    try:
        get_csl()
    except KeyboardInterrupt:
        sys.exit(0)
