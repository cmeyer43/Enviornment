FROM ubuntu:24.04

# add any additional files needed for build and add setup steps for them in _setup_image.sh
COPY _setup* su_reaper.cc /tmp/
RUN bash /tmp/_setup_image.sh

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGAUGE en_US:en
