############################################################
# Dockerfile to build nodejs container                     #
#                                                          #
############################################################

FROM \
ubuntu:jammy

MAINTAINER \
Ryan N. Rankin <Ryan@Rankinmail.net>

# create node user/group first, to be consistent throughout docker variants
RUN \
  set -x \
  && addgroup --system --gid 990 node \
  && adduser --system --disabled-login --ingroup node --no-create-home --home /nonexistent --gecos "node user" --shell /bin/false --uid 990 node \
  && apt-get update \
  && apt install -y git curl

ENV NVM_DIR       /usr/local/nvm
ENV NVM_VERSION   v0.39.3
ENV NODE_VERSION  v14.21.3

# Install nvm with node and npm
RUN \
  mkdir $NVM_DIR \
  && cd $NVM_DIR \
  && git clone https://github.com/nvm-sh/nvm.git . \
  && git checkout $NVM_VERSION \
  && . ./nvm.sh \
  && nvm install $NODE_VERSION \
  && nvm alias default $NODE_VERSION \
  && nvm use default

ENV NODE_PATH   $NVM_DIR/versions/node/$NODE_VERSION/bin/node
ENV NPM_PATH    $NVM_DIR/versions/node/$NODE_VERSION/bin/npm
ENV PATH        $NVM_DIR/$NODE_VERSION/bin:$PATH

# link binaries
RUN \
  ls -lah /usr/local/bin \
  && ln -s $NODE_PATH /usr/local/bin/node \
  && ln -s $NPM_PATH /usr/local/bin/npm

USER node

CMD ["node", "--version"]
