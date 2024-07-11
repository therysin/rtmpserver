Very light image.

Based on:
```
rtmp-server-module commit 2fb11df (aprrox March 2024) (https://github.com/arut/nginx-rtmp-module)
nginx 1.26.1
alpine 3.20
```
Example Compose Usage:

```
version: '3.7'

services:
  rtmpserver:
    image:  ghcr.io/therysin/rtmpserver/rtmp:latest
    container_name: rtmpserver
    restart: unless-stopped
    ports:
      - 1935:1935
```
