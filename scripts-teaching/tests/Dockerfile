FROM alpine:3.20

ENV AWSCLI_VERSION "1.16.243"
ENV TERRAFORM_VERSION="0.12.9"

RUN apk add --no-cache git jq curl \
	python \
    python-dev \
    py-pip \
    build-base \
    && pip install --no-cache-dir "awscli==${AWSCLI_VERSION}" --upgrade --user \
    && apk --purge -v del py-pip \
    && rm -rf /var/cache/apk/*


RUN curl -O https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
	unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/bin/

# hadolint ignore=DL3064
ENV AWS_DEFAULT_REGION=
# hadolint ignore=DL3064
ENV AWS_ACCESS_KEY_ID=
# hadolint ignore=DL3064
ENV AWS_SECRET_ACCESS_KEY=
ENV TF_VAR_student_alias=

RUN mkdir -p /workdir
WORKDIR /workdir

