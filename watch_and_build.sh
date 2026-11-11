#!/bin/sh
find . -type f \( -name "*.css" -o -name "*.html" -o -name "*.elm" \) | entr make
