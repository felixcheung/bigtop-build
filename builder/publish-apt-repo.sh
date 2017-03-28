#!/bin/bash

set -e

if [ -z "$1" -o -z "$2" -o -z "$3" -o -z "$4" ]; then
  echo "usage: $0 <local apt repo path> <storage account name> <storage account key> <container name>"
  exit 1
fi

LOCAL_APT_PATH=$1
STORAGE_ACCOUNT_NAME=$2
STORAGE_ACCOUNT_KEY=$3
CONTAINER_NAME=$4

if [ ! -d "$LOCAL_APT_PATH" ]; then
  echo "Local apt repo path isn't a dir: $LOCAL_APT_PATH."
  exit 1
fi

pushd "$LOCAL_APT_PATH"

blobxfer --storageaccountkey "$STORAGE_ACCOUNT_KEY" "$STORAGE_ACCOUNT_NAME" "$CONTAINER_NAME" .
az storage container set-permission --account-name "$STORAGE_ACCOUNT_NAME" --account-key "$STORAGE_ACCOUNT_KEY" --name "$CONTAINER_NAME" --public-access blob
echo "*****===== APT repo published at: https://${STORAGE_ACCOUNT_NAME}.blob.core.windows.net/${CONTAINER_NAME} =====*****"

popd
