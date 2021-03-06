# mdtemp

This is a very small script that will pretty much just set up a template folder
for a report or simple presentation written in markdown (including a Makefile
    and BibTeX) for then converting the markdown file to a pdf. The setup
    includes getting a proper csl for reference formatting (check available csl
    files [here](https://github.com/citation-style-language/styles), it will
    list all these styles and then curl the one needed). The pdf generation can
    then be run with a simple `make` or `make view` to also open the pdf.

## Installation

Installation is very simple, all you need to do is clone this repo (somewhere where you usually put custom scripts, I
have my scripts in `$HOME/bin/` and have that in my `$PATH`) and export the location of the `mdtemp` folder.

```bash
git clone https://github.com/nicktehrany/mdtemp.git

# Copy the script to your bin dir
cp mdtemp/mdtemp ~/bin/

# Export its location (change dir if you put it somewhere else!)
[ -d $HOME/dotfiles/bin/mdtemp ] && export MDTEMP="$HOME/dotfiles/bin/mdtemp"
```

Note, the checks in the source and export are just there so the shell doesn't throw errors if it can't find the file.

## Usage

Usage is also relatively simple

```bash
mdtemp -d [folder name] [-h] [-c]

Flags:
    -d: Directory Name of the folder to create containing the template files (Default: 'mdtemplate/')
    -c: Initialize Citations, without it will not download CSL
    -h: Help
```

An example will look like:

```bash
# create template with reference format
mdtemp -d report -c
```

Options for .csl files will show up as soon as you start typing the first letter (it uses fuzzy finding!).

The generated Makefile is also rather simple, includes options such as `make report` or `make presentation`
which will give the resulting type as a pdf.
