FROM yanzinetworks/alpine:3.10.1
LABEL maintainer="efrecon@gmail.com"

ARG BAWT_VERSION=1.0.0

# Labels
ARG BUILD_DATE
LABEL org.label-schema.build-date=${BUILD_DATE}
LABEL org.label-schema.schema-version="1.0"
LABEL org.label-schema.name="efrecon/bawt"
LABEL org.label-schema.description="BAWT-based Tcl distribution, compiled from source"
LABEL org.label-schema.url="http://www.bawt.tcl3d.org/"
LABEL org.label-schema.docker.cmd="docker run --rm -it efrecon/bawt"

# Create user
ENV USER=tcler
ENV UID=8690
ENV GID=8690
RUN addgroup --gid "$GID" "$USER" && \
    adduser \
        --disabled-password \
        --gecos "" \
        --ingroup "$USER" \
        --uid "$UID" \
        "$USER"

# Copy BAWT support scripts and package info
COPY Tcl_Only.bawt install.sh /tmp/

# Install OS dependencies, BAWT, run it for installation and cleanup once done
RUN apk --no-cache add bash build-base pkgconfig curl p7zip tzdata linux-headers && \
    curl -Ls http://www.bawt.tcl3d.org/download/Bawt-${BAWT_VERSION}.zip -o /tmp/Bawt-${BAWT_VERSION}.zip && \
    7z x -o/tmp -- /tmp/Bawt-${BAWT_VERSION}.zip && \
    chmod u+x /tmp/Bawt-${BAWT_VERSION}/Build-*.sh /tmp/Bawt-${BAWT_VERSION}/tclkit-* && \
    cp /usr/share/zoneinfo/UTC /etc/localtime && \
    echo "UTC" > /etc/timezone && \
    cp /tmp/Tcl_Only.bawt /tmp/Bawt-${BAWT_VERSION}/Setup/ && \
    cd /tmp/Bawt-${BAWT_VERSION} && \
    ./Build-Linux.sh x64 Setup/Tcl_Only.bawt update && \
    /tmp/install.sh && \
    apk --no-cache del bash build-base pkgconfig curl p7zip && \
    rm -rf /tmp/*.apk /var/cache/apk/* && \
    rm -rf /tmp/Bawt-${BAWT_VERSION}* && \
    rm -rf /tmp/BawtBuild

# Export two volumes, one for tcl code and one for data, just in case.
VOLUME /opt/tcl
VOLUME /opt/data
RUN chown ${UID}:${GID} /opt/tcl /opt/data

# Make sure code put into the special tcl volume can lazily be filled
# with packages
ENV TCLLIBPATH /opt/tcl /opt/tcl/lib

USER ${USER}

# Arrange for a nice prompt
COPY scripts/*.tcl /scripts/
COPY scripts/tclshrc /home/${USER}/.tclshrc

ENTRYPOINT [ "/usr/local/bin/tclsh" ]