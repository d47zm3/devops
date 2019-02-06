FROM centos:latest

LABEL maintainer="d47zm3@gmail.com"
LABEL image_name="security-tools:nmap"

RUN yum -y update
RUN yum -y install wget

FROM centos:latest

COPY --from=0 /usr/bin/wget /usr/bin/
RUN wget -q  "https://nmap.org/dist/?C=M;O=D" -O - | grep "nmap" | grep "rpm" | egrep -v "\.src|update|zenmap" | head -n1 | sed -e 's/<[^>]*>//g' |  egrep -o "nmap.*rpm" | xargs -I FILE wget "https://nmap.org/dist/FILE"
RUN rpm -ivh nmap*
