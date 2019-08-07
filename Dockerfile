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
RUN apk --no-cache add bash build-base pkgconfig curl p7zip tzdata linux-headers &&                          `# install build and run dependencies` \
    curl -Ls http://www.bawt.tcl3d.org/download/Bawt-${BAWT_VERSION}.zip -o /tmp/Bawt-${BAWT_VERSION}.zip && `# Fetch BAWT at proper version` \
    7z x -o/tmp -- /tmp/Bawt-${BAWT_VERSION}.zip &&                                                          `# unzip using one of the dependencies` \
    chmod u+x /tmp/Bawt-${BAWT_VERSION}/Build-*.sh /tmp/Bawt-${BAWT_VERSION}/tclkit-* &&                     `# Force execution on necessary scripts` \
    cp /usr/share/zoneinfo/UTC /etc/localtime &&                                                             `# Fix timezone so BAWT can run properly` \
    echo "UTC" > /etc/timezone && \
    cp /tmp/Tcl_Only.bawt /tmp/Bawt-${BAWT_VERSION}/Setup/ &&                                                `# Copy image-dependent list of packages into BAWT so we can include if necessary` \
    cd /tmp/Bawt-${BAWT_VERSION} &&                                                                          `# BAWT only runs from directory` \
    ./Build-Linux.sh x64 Setup/Tcl_Only.bawt update &&                                                       `# Build, run and install everything. TAKES TIME!` \
    /tmp/install.sh &&                                                                                       `# Install into /usr/local` \
    rm -rf /usr/local/man /usr/local/share/man /usr/local/share/info &&                                      `# Remove documentation to squeeze away space` \
    apk --no-cache del bash build-base pkgconfig curl p7zip &&                                               `# Remove build dependencies` \
    rm -rf /tmp/*.apk /var/cache/apk/* &&                                                                    `# Remove package remains` \
    rm -rf /tmp/Bawt-${BAWT_VERSION}* &&                                                                     `# Remove BAWT itself` \
    rm -rf /tmp/BawtBuild                                                                                    `# Remove what BAWT generated`

# Export two volumes, one for tcl code and one for data, just in case.
RUN mkdir /opt/tcl /opt/data && chown -R ${UID}:${GID} /opt/tcl /opt/data
VOLUME /opt/tcl
VOLUME /opt/data

# Make sure code put into the special tcl volume can lazily be filled
# with packages
ENV TCLLIBPATH /opt/tcl /opt/tcl/lib

# Arrange for a nicer interactive prompt
COPY scripts/*.tcl /scripts/
COPY scripts/tclshrc /home/${USER}/.tclshrc

# Switch to regular user inside container and make the newly built tcl shell the
# entrypoint.
USER ${USER}
ENTRYPOINT [ "/usr/local/bin/tclsh" ]