#!/bin/sh

until [ ${RC} -eq 0 ]; do
    CONFIG=$(wget -qO - --header "Authorization: Bearer ${SHANTY_TOKEN}" ${SHANTY_URL})
    RC=$?
done

for LINE in $(echo ${CONFIG} | jq -r "to_entries|map(\"\(.key)=\(.value|tostring)\")|.[]" ); do
    export ${LINE}
done

envsubst < /var/tmp/msmtprc.tpl > /etc/msmtprc

if [ -z "${MSMTPD_HOST}" ]; then
    MSMTPD_HOST=0.0.0.0
fi

if [ -z "${MSMTPD_PORT}" ]; then
    MSMTPD_PORT=25
fi

LOG="/dev/shm/msmtpd.log"

msmtpd --log=${LOG} --interface=${MSMTPD_HOST} --port=${MSMTPD_PORT} &
PID=$!

tail -F ${LOG} --pid=${PID} 2> /dev/null

wait ${PID}
