#!/bin/bash
#
# File: scripts/always.sh
# 
# By: Daniel Morales <daniminas@gmail.com>
#
# Web: https://github.com/danielm/vagrant-php
#
# Licence: GPL/MIT

# We may need to Start apache manually.
# This is a workarround to fix an issue when apache starts and our shared-folder(documentroot) isnt mounted yet

service apache2 status > /dev/null 2>&1
if [ $? -ne 0 ]; then
    service apache2 start
fi