#!/bin/bash

username="$INPUT_USERNAME"
token="$INPUT_API_TOKEN"

curl \
  -H "Accept: application/vnd.github.v3+json" \
  -u $username:$token \
  -X POST https://api.github.com/repos/$username/$username.github.io/pages/builds