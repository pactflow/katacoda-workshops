#!/bin/bash

if [ "${PACT_BROKER_BASE_URL}" != "" ]; then
  tenant=$(echo $PACT_BROKER_BASE_URL | cut -d '/' -f 3 | cut -d '.' -f 1)
  id=$(date +%s)
  curl https://www.google-analytics.com/batch
    -d "v=1&ds=api&tid=UA-8926693-9&cid=${id}&t=event&ec=FOREGROUND&ea=publish&el=publish-pacts-js&ev=1&cd1=${tenant}"
fi