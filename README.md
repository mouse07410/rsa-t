# rsa-t

Shows how to invoke from Haskell RSA KEM provided by the Botan-3 library.

This demo is geared to Stack, btu it includes .cabal file (rsa-t.cabal-tested)
in case you want to build this demo with Cabal instead of Stack.

This has been tested with the latest released Cabal-3.10.2.1, and Stack-2.15.3.
GHC employed was 9.8.2, but also tested with 9.4.8.

## Usage

First, install Haskell toolchain - ideally, with GHCup. I typically use
Cabal, but always install Cabal and Stack.

Installing HLS is a very good idea. 

Clone this repo, and go there, e.g.:

```sh
$ git clone https://github.com/mouse07410/rsa-t.git
$ cd rsa-t
```

### Cabal

Just doing `cabal run --cabal-file ./rsa-t.cabal-tested` 
should be sufficient.

### Stack

Do `stack run`


Enjoy!

