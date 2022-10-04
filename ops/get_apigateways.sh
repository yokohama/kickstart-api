#!/bin/sh

REASION=ap-northeast-1
STAGE=prod

aws apigateway get-rest-apis | jq -r '.items[] | "\(.name) = https://\(.id).execute-api.'${REASION}'.amazonaws.com/'${STAGE}'"'
