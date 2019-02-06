FROM python:3.5-alpine
LABEL maintainer="d47zm3@gmail.com"
LABEL image_name="security-tools:trufflehog"
RUN apk add --no-cache git openssh && pip install trufflehog && pip install codestyle
#RUN adduser -S truffleHog
#USER truffleHog
WORKDIR /proj
ENTRYPOINT [ "trufflehog" ]
CMD [ "-h" ]
