# BAWT-based Tcl Distribution

This is an Alpine-based Tcl distribution that is compiled from source using
[BAWT]. Compared to other efforts such as [efrecon/mini-tcl], this image
provides a larger set of packages, sometimes at a later version than the
versions that come out of the box from the Alpine distribution. It also leaves
the development version of the libraries available, meaning that compiling Tcl
additional packages should be possible.

  [BAWT]: http://www.bawt.tcl3d.org/
  [efrecon/mini-tcl]: https://hub.docker.com/r/efrecon/mini-tcl/

The image comes with a different set of packages than [efrecon/mini-tcl].
Documentation is automatically squeezed away after the build and install process
to keep the size of the image as low as possible.

## Running

The image uses the Tcl shell at the latest version supported by [BAWT] as an
entrypoint. As a result, entering the following command should provide you with
a basic Tcl interactive prompt that has access to all the libraries comprised in
the image. Interactive prompts run a slightly modified version of the Tcl-only
[readline] for ease of use.

```shell
docker run -it --rm efrecon/bawt
```

  [readline]: https://wiki.tcl-lang.org/page/Pure-tcl+readline2

## Building

To build, simply write the following command, from the main directory of this
project.

```shell
docker build -t efrecon/bawt .
```

The image uses the build argument `BAWT_VERSION` to point to the official
[version] of [BAWT]. To run for an older version of BAWT, e.g. `0.9.1`, you
could enter the following command instead. This would however still use the list
of packages stated for the image, so getting the list of packages that came with
an earlier version of BAWT would require tweaking [Tcl_Only.bawt].


```shell
docker build -t efrecon/bawt:0.9.1 --build-arg BAWT_VERSION=0.9.1 .

```

  [version]: http://www.bawt.tcl3d.org/history.html#releases

## List of Packages

The list of packages is formalised through the default script file called
[Tcl_Only.bawt].

  [Tcl_Only.bawt]: ./Tcl_Only.bawt
