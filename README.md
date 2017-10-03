## Description
The reproduces the case described in [Shougo/neosnippet.vim#402](https://github.com/Shougo/neosnippet.vim/issues/402/)

## Setup
the Flow binary needs to be available for the language server to offer completion candidates. To install it, simply `cd` to the cloned dir and run the `yarn` command. Alternatively, you can use `npm install`.

## Usage
The repository contains a `minimal.vim` file, that reproduces the issue.
run `vim -u ./minimal.vim index.js` to edit the example file while using it.
