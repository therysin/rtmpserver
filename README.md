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
