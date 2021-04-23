FROM ubuntu:20.04

USER root

# General updating
RUN apt-get update -y && apt-get upgrade -y

# Instll required packages
RUN set -ex && cd ~ \
  && apt-get install -y apt-utils 2>&1 \
  && apt-get install -y curl gnupg gnupg1 gnupg2 unzip

# Install Terraform
ARG TERRAFORM_VERSION=0.14.10
ARG TERRAFORM_SHA256SUM=45d4a12ca7b5c52983f43837d696f45c5ed9ebe536d6b44104f2edb2e1a39894
RUN set -ex && cd ~ \
  && curl -sSLO https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
  && [ $(sha256sum terraform_${TERRAFORM_VERSION}_linux_amd64.zip | cut -f1 -d ' ') = ${TERRAFORM_SHA256SUM} ] \
  && unzip -o -d /usr/local/bin -o terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
  && rm -vf terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# Install Golang
ARG GOLANG_VERSION=1.16.3
ARG GOLANG_SHA256SUM=951a3c7c6ce4e56ad883f97d9db74d3d6d80d5fec77455c6ada6c1f7ac4776d2
RUN set -ex && cd ~ \
  && curl -sSLO https://golang.org/dl/go${GOLANG_VERSION}.linux-amd64.tar.gz \
  && [ $(sha256sum go${GOLANG_VERSION}.linux-amd64.tar.gz | cut -f1 -d ' ') = ${GOLANG_SHA256SUM} ] \
  && tar -C /usr/local/ -xzf go${GOLANG_VERSION}.linux-amd64.tar.gz \
  && rm -v go${GOLANG_VERSION}.linux-amd64.tar.gz \
  && export PATH=$PATH:/usr/local/go/bin

ENTRYPOINT [ "/bin/sh" ]