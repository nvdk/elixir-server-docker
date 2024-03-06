FROM elixir:1.16-slim

RUN mkdir /app; mix local.hex --force

COPY setup.sh /
COPY startup.sh /

RUN apt-get update && \
    apt-get install -y --no-install-recommends iproute2 git &&\
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN mix local.rebar --force
RUN mix local.hex

ENV RUNNING_IN_DOCKER="true"
ENV DEVELOPMENT=""

CMD ["/startup.sh"]

EXPOSE 4000
EXPOSE 80
