#!/usr/bin/env bash

if [ -z "$1" ]
then
  echo "Usage: must pass the terraform directory"
  exit 1
fi
cd $1
terraform $2
