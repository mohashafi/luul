#!/bin/bash

set -e

echo 'BEGIN postDeploy.sh'

bin/typo3 backend:lock
bin/typo3 extension:setup
bin/typo3 language:update
bin/typo3 database:updateschema "*" --verbose
bin/typo3 cache:flush
bin/typo3 upgrade:run
bin/typo3 cache:warmup
bin/typo3 backend:unlock

echo 'END postDeploy.sh'
