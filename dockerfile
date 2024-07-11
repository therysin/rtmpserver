FROM alpine:3.20 AS builder

# Install build dependencies
RUN apk add --no-cache \
    gcc \
    libc-dev \
    make \
    openssl-dev \
    pcre-dev \
    zlib-dev \
    linux-headers \
    curl \
    git

# Set build arguments
ARG NGINX_VERSION=1.26.1
ARG RTMP_MODULE_VERSION=1.2.2

# Download and unpack NGINX source
RUN curl -L https://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz | tar xz

# Clone RTMP module repository
RUN git clone --depth 1 https://github.com/arut/nginx-rtmp-module.git

# Build NGINX with RTMP module
RUN cd nginx-${NGINX_VERSION} && \
    ./configure \
        --prefix=/usr/local/nginx \
        --with-http_ssl_module \
        --with-http_v2_module \
        --with-threads \
        --with-file-aio \
        --add-module=../nginx-rtmp-module && \
    make && \
    make install

# Remove source files and build dependencies
RUN rm -rf nginx-${NGINX_VERSION} nginx-rtmp-module && \
    apk del gcc libc-dev make openssl-dev pcre-dev zlib-dev linux-headers curl git

# Create the final image
FROM alpine:3.20

# Install runtime dependencies
RUN apk add --no-cache openssl pcre libstdc++ ffmpeg

# Copy built NGINX from builder stage
COPY --from=builder /usr/local/nginx /usr/local/nginx

# Create a directory for NGINX configuration
RUN mkdir -p /etc/nginx

# Copy the NGINX configuration file
COPY nginx.conf /usr/local/nginx/conf

# Expose RTMP port
EXPOSE 1935

# Start NGINX
CMD ["/usr/local/nginx/sbin/nginx", "-g", "daemon off;"]
