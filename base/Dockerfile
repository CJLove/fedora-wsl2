FROM fedora:32



RUN \
    dnf update --nogpgcheck -y && \
    dnf install --nogpgcheck -y sudo openssh openssh-clients iputils net-tools which && \
    groupadd -g 1000 love  && \
    useradd -g 1000 -u 1000 -m love && \
    echo "love ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/love 
