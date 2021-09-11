# mdtemp

This is a very small script that will pretty much just set up a template folder for a report written in markdown
(including a Makefile and BibTeX) for then converting the markdown file to a pdf. The setup includes getting a proper
csl for reference formatting (check available csl files [here](https://github.com/citation-style-language/styles), it
will list all these styles and then curl the one needed). The pdf generation can then be run with a simple `make` or
`make view` to also open the pdf.

## Installation

Installation is very simple, all you need to do is clone this repo (somewhere where you usually put custom scripts, I
put it in `$HOME/.config/`) and source the script in your `.bashrc` or `.zshrc` or any other shell you use, and finally
export the location of the `mdtemp` folder.

```bash
git clone https://github.com/nicktehrany/mdtemp.git

# source the mdtemp script (change to the location where you have it stored!)
[ -f $HOME/.config/env/mdtemp/mdtemp.sh ] && source $HOME/.config/env/mdtemp/mdtemp.sh

# export the location (change to the location where you have it stored!)
[ -d $HOME/.config/env/mdtemp ] && export MDTEMP="$HOME/.config/env/mdtemp"
```

Note, the checks in the source and export are just there so the shell doesn't throw errors if it can't find the file.

## Usage

Usage is also relatively simple

```bash
mdtemp -d directory [-h] [-c]

Flags:
    -d: Directory Name, which will be created with the template files [Required!]
    -c: Initialize Citations, without it will not download CSL
    -h: Help
```

An example will look like:

```bash
# create template with reference format
mdtemp -d report -c
```

Options for .csl files will show up as soon as you start typing the first letter (it uses fuzzy finding!).
