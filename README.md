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
"$(command -v docker || command -v podman)" pull ghcr.io/shakiyam/oci-cli
```

Usage
-----

Run the `oci` command (recommended) or use the following:

```console
docker container run \
  --name oci$$ \
  --rm \
  -e HOME="$HOME" \
  -e USER_NAME="$(id -un)" \
  -i \
  -t \
  -u "$(id -u):$(id -g)" \
  -v "$HOME/.oci:$HOME/.oci" \
  $([[ -v OCI_CLI_PROFILE ]] && echo "-e OCI_CLI_PROFILE=$OCI_CLI_PROFILE") \
  ghcr.io/shakiyam/oci-cli "$@"
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
