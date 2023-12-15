# mame-docker: tim011 [![Test status](https://github.com/filmil/mame-docker/workflows/Test/badge.svg)](https://github.com/filmil/mame-docker/workflows/Test/badge.svg)

TIM-011 in a docker container.

## Prerequisites

* docker
* GNU make

## Run

```
make run
```

## Caveats

* Docker image download could last a long time the first time around.
* Once the program starts, focus the window that opens and press "enter"
  on each prompt.
* System boot takes quite a while. It may take a few minutes for first output
  to appear.
