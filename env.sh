#!/usr/bin/env bash

export github_user="dockerizer"
export file="README.md"
export gitkey="bf571c4fd307228749448e893d666ee26e3e56e7"

# load curl with your credentials
alias curl="curl -H 'Authorization: token $gitkey'"
