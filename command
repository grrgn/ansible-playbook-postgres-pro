docker run --detach --privileged --tmpfs /tmp --tmpfs /run --volume=/sys/fs/cgroup:/sys/fs/cgroup:rw --cgroupns=host --name almalinux9-systemd --hostname almalinux9 grrg/almalinux9-systemd:1.0.0 && \
docker run --detach --privileged --tmpfs /tmp --tmpfs /run --volume=/sys/fs/cgroup:/sys/fs/cgroup:rw --cgroupns=host --name debian12-systemd --hostname debian12 grrg/debian12-systemd:1.0.0
