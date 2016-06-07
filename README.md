# Solidity smart contract to test Eris permissions
This is meant to be a simple test of the permissions system in Eris, and specifically attempts to assign arbitrary roles to accounts and then interrogate said permissions when a call is made to a contract. Right now, I am unable to restrict actions based on setting roles (it just doesn't seem to work), but hopefully we can figure out what I'm doing wrong!

The experiment itself comprises a simple contract with two counters (red and blue), with a single function, `increment`, which attempts to increment a counter provided the caller has the relevant role.

### Prerequisites
I'm running a basic, local chain. The following instructions should allows anybody else to recreate my exact setup. Note, the `epm.yaml` file in this repo will need to be updated with the addresses belonging to the users generated when a new chain is created.

This test was developed on Mac OSX (el cap), and uses the following versions:

* docker (1.11.1)
* docker-machine (0.7.0)
* eris (0.11.4)

Setup a new VM to run Eris experiments:

```
$ docker-machine create --driver virtualbox eris
$ eval $(docker-machine env eris)
```

One may use homebrew to install Eris:

```
$ brew update
$ brew install eris
$ eris init
```

The `init` command above may take a little time to complete as it downloads the various images required to run Eris. The following will create and start a test chain to be used by this experiment:

```
$ eris services start keys
$ eris chains make --account-types=Root:2,Full:1 testchain
$ eris chains new testchain --dir ~/.eris/chains/testchain/testchain_full_000
```

Now grab the 2 root addresses created and replace the addresses in the `epm.yaml` file.

```
$ cat ~/.eris/chains/testchain/addresses.csv
<abc123>,testchain_full_000
<efg456>,testchain_root_000
<hij789>,testchain_root_001
```

### Deploying and running the contract
Retrieve the full address and assign it to an environment variable (this will be one of the addresses in the output of the previous command):

```
$ ADDR=$(cat ~/.eris/chains/testchain/addresses.csv | grep testchain_full_000 | cut -d ',' -f 1)
```

Now, from inside the directory containing the `epm.yaml` file:

```
$ eris pkgs do --chain testchain --address $ADDR
```

When running this experiment, it can be helpful to open a separate terminal window/tab and tail the logs for inspection by running `eris chains logs testchain -f`. At present, the logs indicate that both counters are being incremented, even through the relevant role hasn't been assigned.

