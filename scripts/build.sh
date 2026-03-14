#!/bin/bash
set -e

# Copy customized config files into the quartz submodule before building
cp quartz.config.ts quartz/
cp quartz.layout.ts quartz/

cd quartz
npm install
npx quartz build -d ../content
