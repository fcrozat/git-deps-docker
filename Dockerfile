FROM opensuse:13.2
MAINTAINER Frederic Crozat "<fcrozat@suse.com>"
# based on Paul Wellner Bou "<paul@wellnerbou.de>"

RUN zypper ref && zypper --non-interactive install --no-recommends \
        vim less git-core net-tools python-pygit2 python-Flask ca-certificates-mozilla

ENV DATE 2015-08-25

# Cloning git-deps and resetting to a known working revision, compatible with this Dockerfile
# This step might be cached, so use --no-cache building the image or change the date environment variable to now
RUN git clone https://github.com/aspiers/git-deps.git

RUN ln -s $PWD/git-deps/git-deps /usr/bin/git-deps

RUN npm install -g browserify
RUN cd git-deps/html && npm install && browserify -t coffeeify -d js/git-deps-graph.coffee -o js/bundle.js

RUN mkdir -p /src
VOLUME /src
WORKDIR /src

EXPOSE 5000

CMD ["git", "deps", "--serve", "--bind-ip=0.0.0.0"]

