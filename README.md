oci-cli-docker
==============

[oci-cli (Command Line Interface for Oracle Cloud Infrastructure)](https://github.com/oracle/oci-cli) Docker Image

Installation
------------

```console
curl -L# https://raw.githubusercontent.com/shakiyam/oci-cli-docker/master/oci \
  | sudo tee /usr/local/bin/oci >/dev/null
sudo chmod +x /usr/local/bin/oci
docker pull shakiyam/oci-cli
```

Usage
-----

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
