#!/usr/bin/env bash

if [ "${EG_IMPERSONATION_ENABLED}" = "True" ]; then
#        IMPERSONATION_OPTS="--proxy-user ${KERNEL_USERNAME:-UNSPECIFIED}"
        USER_CLAUSE="as user ${KERNEL_USERNAME:-UNSPECIFIED}"
else
#        IMPERSONATION_OPTS=""
        USER_CLAUSE="on behalf of user ${KERNEL_USERNAME:-UNSPECIFIED}"
fi

echo
echo "Starting IRkernel for Spark in Kubernetes mode ${USER_CLAUSE}"
echo

if [ -z "${SPARK_HOME}" ]; then
  echo "SPARK_HOME must be set to the location of a Spark distribution!"
  exit 1
fi

if [ -z "${KERNEL_ID}" ]; then
  echo "KERNEL_ID must be set for discovery and lifecycle management!"
  exit 1
fi

PROG_HOME="$(cd "`dirname "$0"`"/..; pwd)"

set -x
eval exec \
     "${SPARK_HOME}/bin/spark-submit" \
     "${SPARK_OPTS}" \
     "local://${PROG_HOME}/scripts/launch_IRkernel.R" \
     "${LAUNCH_OPTS}" \
     "$@"
set +x
