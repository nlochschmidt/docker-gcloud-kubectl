FROM docker
MAINTAINER "Niklas Lochschmidt <nlochschmidt@gmail.com>"

# Install Google Cloud SDK with the gcr credentials helper and kubectl but otherwise identical to
# https://github.com/sbani/docker-google-gloud-sdk-alpine/tree/master/slim
RUN apk add --no-cache --virtual .build-deps \
		curl \
	&& apk add --no-cache --virtual .cloudsdk-rundeps \
		openssh-client \
		python \
	&& curl -fSL https://dl.google.com/dl/cloudsdk/channels/rapid/google-cloud-sdk.tar.gz -o google-cloud-sdk.tar.gz \
	&& tar -xzf google-cloud-sdk.tar.gz \
	&& google-cloud-sdk/install.sh \
		--usage-reporting=false \
		--path-update=true \
		--bash-completion=false \
		--rc-path=/.bashrc \
		--additional-components kubectl docker-credential-gcr \
	&& google-cloud-sdk/bin/gcloud config set --installation component_manager/disable_update_check true \
	&& sed -i -- 's/\"disable_updater\": false/\"disable_updater\": true/g' /google-cloud-sdk/lib/googlecloudsdk/core/config.json

RUN mkdir /.ssh
ENV PATH /google-cloud-sdk/bin:$PATH
VOLUME ["/.config"]
CMD ["/bin/sh"]