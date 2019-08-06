# BAWT-based Tcl Distribution

This is an Alpine-based Tcl distribution that is compiled from source using
[BAWT]. Compared to other efforts such as [efrecon/mini-tcl], this image
provides a larger set of packages, sometimes at a later version than the
versions that come out of the box from the Alpine distribution.

  [BAWT]: http://www.bawt.tcl3d.org/
  [efrecon/mini-tcl]: https://hub.docker.com/r/efrecon/mini-tcl/

## Running

The image uses the Tcl shell at the latest version supported by [BAWT] as an
entrypoint. As a result, entering the following command should provide you with
a basic Tcl interactive prompt that has access to all the libraries comprised in
the image.

```shell
docker run -it --rm efrecon/bawt
```

## Building

To build, simply write the following command, from the main directory of this
project.

```shell
docker build -t efrecon/bawt .
```

The image uses the build argument `BAWT_VERSION` to point to the official
[version] of [BAWT]. To run for an older version of BAWT, e.g. `0.9.1`, you
could enter the following command instead.

```shell
docker build -t efrecon/bawt:0.9.1 --build-arg BAWT_VERSION=0.9.1 .

```

  [version]: http://www.bawt.tcl3d.org/history.html#releases

## List of Packages

The list of packages is formalised through the default script file called
[Tcl_Only.bawt](./Tcl_Only.bawt).
