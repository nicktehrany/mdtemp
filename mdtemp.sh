#!/usr/bin/env bash

GREEN=$'\033[1;32m'
RED=$'\033[1;31m'

function __usage_mdtemp() {
    printf "Usage: cmd [-d directory] [-h] [-c]\nFlags:\n\t-d: Directory Name\n\t-c: Initialize Citations\n\t-h: Help\n"
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

function __init_cite() {
    if [ -f $MDTEMP/csl_getter.py ]; then
        python3 $MDTEMP/csl_getter.py -m main
    else
        printf "${RED}Can't find csl_getter.py. Exiting."
        exit 0
    fi
    if [ $? != 0 ]; then
        exit 0
    fi
    csl=$(cat tmp.txt)
    rm tmp.txt
    status_code=$(curl --write-out %{http_code} -so $PWD/$DIR/$csl -OL https://raw.githubusercontent.com/citation-style-language/styles/master/$csl)
    if [ "$status_code" -ne 200 ]; then
        printf "${RED}Invalid CSL. Exiting.\n"
        exit 0
    fi
}

function mdtemp() {
    citations="false"
    DEPS="main.md"
    CITE=""
    CSL="---"
    CMD=""
    unset DIR

    [ $# -lt 1 ] && __usage_mdtemp
    while getopts "d:ch" opt; do
        case ${opt} in
            d)
                DIR=${OPTARG}
                ;;
            c)
                citations=true
                ;;
            h | *)
                __usage_mdtemp
                exit 0
                ;;
        esac
    done
    shift $((OPTIND -1))

    if [ -z "$DIR" ]; then
        printf "${RED}Missing -d argument. Exiting."
        exit 0
    fi
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

    [ "$citations" = "true" ] && __init_cite && printf "@inproceedings{Tehrany2020EvaluatingPC, \ttitle={Evaluating Performance Characteristics of the PMDK Persistent Memory Software Stack}, \tauthor={Nick Tehrany},\tyear={2020}\n}\n" > $PWD/$DIR/main.bib && DEPS="main.md main.bib" && CITE="\nThis is how a citation works @Tehrany2020EvaluatingPC \n# References\n" && CSL="csl: $csl\n\055--" && CMD="\055-bibliography main.bib" printf "DOC = main\nDEPS = $DEPS\n\n.PHONY: all view\n\nall: report\n\nreport: \$(DEPS)\n\tpandoc \$(DOC).md -o main.pdf $CMD\n\nview: report\n\txdg-open \$(DOC).pdf" > $PWD/$DIR/Makefile

    printf "\055--\ntitle: Title\nauthor: Author\ndate: $(date +'%B %d %Y')\n$CSL\n$CITE" > $PWD/$DIR/main.md
    printf "${GREEN}Finished setting up template!\n"
}
