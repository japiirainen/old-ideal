# Table of contents

- [Table of contents](#table-of-contents)
- [`ideal`](#ideal)
- [Usage](#usage)
    - [Nix](#nix)
    - [Cargo](#cargo)
- [Development](#development)
- [Meaning of the name](#meaning-of-the-name)

## `ideal`

`ideal` is primarily a computer algebra system, but it also can be used as a
more general purpose programming language.

## Usage

### Nix

The easiest way to try `ideal` is via `nix`:

```bash
nix run github:japiirainen/ideal
```

### Cargo

If you are not a `nix` user, you can compile and run `ideal` via `cargo`:

Clone the project:

```bash
git clone https://github.com/japiirainen/ideal
cd ideal
```

... and run with `cargo`:

```bash
cargo run
```

## Development

The development flow is optimized for `nix` users. The projects `Makefile` contains
many useful commands for common development needs, such as building, linting and
formatting.

## Meaning of the name

TODO
