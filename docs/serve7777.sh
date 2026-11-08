#!/usr/bin/env bash
cd -- "$(dirname -- "${BASH_SOURCE[0]}")"
# exec python3 -m http.server 7777
jwebserver -p 7777
