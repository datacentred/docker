#!/usr/bin/env bash
 
export OS_AUTH_URL=https://compute.datacentred.io:5000/v2.0
echo "Please enter your DataCentred OpenStack username: "
read -r OS_USERNAME
export OS_USERNAME=$OS_USERNAME
echo "Please enter your project name: "
read -r OS_TENANT_NAME
export OS_TENANT_NAME=$OS_TENANT_NAME
echo "And finally, please enter your password: "
read -sr OS_PASSWORD
export OS_PASSWORD=$OS_PASSWORD
