#!/bin/bash

if [ $1 == "continue_on_error" ]
then
    set +e 
else  # stop on error
    set -e
fi

# Search a resource group inside Azure"
function assertRG {
    export name=$1 
    export inv=$2   
    printf "\e[1;37mTesting Resourgroup $name - "
    az resource list | jq  -e 'contains( [{ name: env.name }] )' > /dev/null
    if [ $? -eq 1 ]
        then printf "\e[0;31mFailed...$rc\n"
        else printf "\e[0;32mSuccess...$rc\n"
    fi
}

# Search a resource inside Azure RG"
function assertResource {
    export rg=$1
    export resource_type=$2  # i.e. Microsoft.KeyVault/vaults
    export resource_name=$3    
    printf "\e[1;37mTesting Resource Group: $rg, Type: $resource_type, Name: $resource_name - "
    az resource list -g $rg --resource-type $resource_type | jq  -e 'contains( [{ name: env.resource_name }] )' > /dev/null
    if [ $? -eq 1 ]
        then printf "\e[0;31mFailed...$rc\n"
        else printf "\e[0;32mSuccess...$rc\n"
    fi
}