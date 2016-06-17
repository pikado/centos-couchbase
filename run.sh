#!/bin/bash

/opt/couchbase/bin/couchbase-server -- -noinput &
CB_PID=$!
sleep 10
if [ -z "$CB_ADMIN_PASS" ]; then
echo "Error: CB_ADMIN_PASS parameter missing, cannot automatically install Couchbase, continue manually from web management console"
else
/opt/couchbase/bin/couchbase-cli cluster-init -c localhost:8091 --cluster-init-username=Administrator --cluster-init-password=${CB_ADMIN_PASS} --cluster-init-ramsize=${CB_RAMSIZE:-600}
/opt/couchbase/bin/couchbase-cli bucket-create -c localhost:8091 --bucket=${CB_BUCKET_NAME:-default} --bucket-type=couchbase --bucket-port=11211 --bucket-ramsize=${CB_BUCKET_RAMSIZE:-300} --bucket-replica=1 -u Administrator -p ${CB_ADMIN_PASS}
fi

wait $CB_PID 2>/dev/null
