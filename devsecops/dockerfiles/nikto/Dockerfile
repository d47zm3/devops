FROM ubuntu:18.10

LABEL maintainer="d47zm3@gmail.com"
LABEL image_name="security-tools:nikto"

RUN apt update
RUN apt -y upgrade
RUN apt -y install git wget libcrypt-ssleay-perl
RUN mkdir /opt/tools

# nikto
RUN cd /opt/tools && git clone https://github.com/sullo/nikto nikto
RUN mv /opt/tools/nikto/program/* /usr/local/bin/
RUN ln -s /usr/local/bin/nikto.pl /usr/local/bin/nikto

WORKDIR /usr/local/bin/
ENTRYPOINT ["/usr/local/bin/nikto.pl"]
