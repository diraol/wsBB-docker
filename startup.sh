#!/bin/bash

export LANG="pt_BR.UTF-8"

if [ -n "${XAUTHORITY}" ] && [ -n "${HOST_HOSTNAME}" ]
then
  if [ "${HOSTNAME}" != "${HOST_HOSTNAME}" ]
  then
    [ -f ${XAUTHORITY} ] || touch ${XAUTHORITY}
    xauth add ${HOSTNAME}/unix${DISPLAY} . \
    $(xauth -f /tmp/.docker.xauth list ${HOST_HOSTNAME}/unix${DISPLAY} | awk '{ print $NF }')
  else
    cp /tmp/.docker.xauth ${XAUTHORITY}
  fi
fi

if [ ! -d ~/.mozilla ]
then
  firefox -CreateProfile BBPJ \
  && su -c "apt -o Acquire::ForceIPv4=true update && apt -y -o Acquire::ForceIPv4=true upgrade && apt -y install /src/warsaw_setup64.deb" # \
  # A3 Cert BB Module. Needs JAVA.
  # && java -jar /src/bb_modulo_assinatura_linux.jar
else
  su -c "/etc/init.d/warsaw start"
fi

/usr/local/bin/warsaw/core \
&& firefox -P BBPJ https://aapj.bb.com.br/aapj/loginpfe.bb
