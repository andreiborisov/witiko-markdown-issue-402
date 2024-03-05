FROM alpine:3.19.1

RUN mkdir -p /data/context && mkdir -p /data/context/bin

COPY context-linuxmusl-64/install.sh /data/context/install.sh
COPY context-linuxmusl-64/bin/* /data/context/bin/

RUN cd /data/context \
  && chmod +x install.sh \
  && ./install.sh

ENV PATH=/data/context/tex/texmf-linuxmusl-64/bin:$PATH

# Install Markdown package
RUN apk add --no-cache wget \
  && cd /data/context \
  && wget -4 https://github.com/Witiko/markdown/releases/download/3.4.1/markdown.zip \
  && unzip markdown.zip \
  && mkdir -p tex/texmf-modules \
  && unzip markdown.tds.zip -d tex/texmf-modules \
  && context --generate \
  && rm -rf markdown markdown.zip markdown.tds.zip \
  && apk del --no-cache wget

RUN addgroup -g 1000 context \
  && adduser -u 1000 -G context -D context

USER context
WORKDIR /home/context
