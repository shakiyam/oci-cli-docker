oci-cli-docker
==============

[oci-cli (Command Line Interface for Oracle Cloud Infrastructure)](https://github.com/oracle/oci-cli) Docker Image

oci-cli-docker supports docker and podman on x86-64 and arm64.

Installation
------------

You can install by following these steps:

```console
curl -L# https://raw.githubusercontent.com/shakiyam/oci-cli-docker/master/oci \
  | sudo tee /usr/local/bin/oci >/dev/null
sudo chmod +x /usr/local/bin/oci
"$(command -v docker || command -v podman)" pull docker.io/shakiyam/oci-cli
```

Usage
-----

To use cli 

```console
docker container run \
  --name oci$$ \
  --rm \
  -i \
  -t \
  -e USER_NAME="$(id -un)" \
  -e HOME="$HOME" \
  -u "$(id -u):$(id -g)" \
  -v "$HOME/.oci:$HOME/.oci" \
  shakiyam/oci-cli "$@"
```

To get help with the command line:

```console
oci --help
```

or

```console
oci --h
```

For detailed documentation of the CLI, see [here](https://docs.cloud.oracle.com/Content/API/Concepts/cliconcepts.htm).

Author
------

[Shinichi Akiyama](https://github.com/shakiyam)

License
-------

[MIT License](https://opensource.org/licenses/MIT)
