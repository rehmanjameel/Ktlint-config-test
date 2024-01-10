#!/bin/bash

# Download ktlint
curl -sSLO https://github.com/pinterest/ktlint/releases/download/1.1.1/ktlint

# Make the downloaded file executable
chmod a+x ktlint

# Move ktlint to /usr/local/bin/ with sudo privileges
sudo mv ktlint /usr/local/bin/

echo "ktlint has been installed successfully."

