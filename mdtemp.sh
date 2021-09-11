#!/bin/bash

set -e

function __usage() {
    echo "Usage: cmd [-d directory] [-h]"
}


function __check_response(){
    if [[ "$1" == "Y" || "$1" == "y" ]]; then
        echo 0
    elif [[ "$1" == "N" || "$1" == "n" ]]; then
        echo 1
    else
        echo 2
    fi
}

function mdtemp() {
    citations=false
    DEPS="main.md"
    CITE=""
    CSL="---"

    [ $# -lt 1 ] && __usage
    while getopts "d:ch" opt; do
        case ${opt} in
            d)
                DIR=${OPTARG}
                ;;
            c)
                citations=true
                ;;
            h | *)
                __usage
                exit 0
                ;;
        esac
    done
    shift $((OPTIND -1))
    if [ -e ${PWD}/$DIR ]; then
        printf "The folder already exists. Overwrite it? (y/n): "
        read -r create
        response=$(__check_response $create)
        if [[ "$response" == "0" ]]; then
            rm -r $PWD/$DIR
            mkdir $PWD/$DIR
        else
            echo "Exiting"
            return 1
        fi
    else
        mkdir $PWD/$DIR
    fi

    [ $citations == true ] && printf "@inproceedings{Tehrany2020EvaluatingPC,\n\ttitle={Evaluating Performance Characteristics of the PMDK Persistent Memory Software Stack},\n\tauthor={Nick Tehrany},\n\tyear={2020}\n}\n" > $PWD/$DIR/main.bib && DEPS="main.md main.bib" && CITE="\nThis is how a citation works @Tehrany2020EvaluatingPC\n\n# References\n" && CSL="csl: acm-computing-surveys.csl\n\055--"

    printf "DOC = main\nDEPS = $DEPS\n\n.PHONY: all view\n\nall: report\n\nreport: \$(DEPS)\n\tpandoc \$(DOC).md -o main.pdf\n\nview: report\n\txdg-open \$(DOC).pdf" > $PWD/$DIR/Makefile

    printf "\055--\ntitle: Title\nauthor: Author\ndate: $(date +'%B %d %Y')
$CSL
$CITE" > $PWD/$DIR/main.md
}


# TEMP: calling to run it
mdtemp $@
