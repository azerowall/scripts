#!/bin/bash

# For ubuntu 20.04
# Run server:
# vncserver -localhost no -geometry 1280x600 :1 -fg

# fix debconf warnings
export DEBIAN_FRONTEND=noninteractive

RUN apt update \
    && apt install -y sudo procps nano less curl \
    lxqt dbus-x11 tigervnc-standalone-server

RUN adduser --disabled-password --gecos "" "${USER}" \
    && echo "${USER}:${PASS}" | chpasswd \
    && usermod -a -G sudo "${USER}"

su "${USER}"
cd ~

tee .vnc/.xstartup << END
#!/bin/bash
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
exec startlxqt
END

chmod +x .vnc/.xstartup

echo "${VNCPASS}" | vncpasswd -f > .vnc/passwd
chmod 600 .vnc/passwd
