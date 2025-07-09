#!/bin/bash

if [[ -z "${WAIT_FOR}" ]]; then
  echo "no WAIT_FOR variable set ..."
else
  echo "waiting for ${WAIT_FOR} to be ready ..."
  _waitcounter=0
  while [[ "$(curl -s -o /dev/null -w ''%{http_code}'' ${WAIT_FOR})" != "200" ]]; do
    _waitcounter=$((_waitcounter+1))
    echo "still waiting for ${WAIT_FOR} ... #${_waitcounter}"
    sleep 5;
  done
fi

ls -la /app

composer install

./flow database:setcharset
./flow doctrine:migrate

./flow user:create --roles Administrator $ADMIN_USERNAME $ADMIN_PASSWORD LocalDev Admin || true

./flow resource:publish
./flow flow:cache:flush
./flow cache:warmup

./flow server:run --host 0.0.0.0
