#!/bin/bash
:url="https://aristotle.harmonic.fun/api/v3/project"
:api_key="$ARISTOTLE_API_KEY"
:
curl -si -H "Authorization: Bearer $api_key" "$url" 2>&1
