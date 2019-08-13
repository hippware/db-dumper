FROM alpine:3.10

MAINTAINER Bernard Duggan <bernard@hippware.com>

RUN apk --no-cache --update upgrade
RUN apk add postgresql-client py2-pip vault
RUN pip install --upgrade pip
RUN pip install awscli

COPY dump_db.sh /

CMD /dump_db.sh
