# DelphiPi

**Computing Pi in Delphi** — A standalone project featuring BBP and Chudnovsky algorithms for computing digits of Pi, powered by [Rudy's Big Numbers Library](https://github.com/TurboPack/RudysBigNumbers).

## Overview

DelphiPi demonstrates high-precision computation of Pi using:
- **BBP (Bailey–Borwein–Plouffe)** — computes individual hexadecimal digits of Pi without computing preceding digits
- **Chudnovsky** — a rapidly converging series for computing Pi to arbitrary precision

Both algorithms use `Velthuis.BigDecimals` and `Velthuis.BigIntegers` from RudysBigNumbers for arbitrary-precision arithmetic.

## Projects

| Project | Description |
|---------|-------------|
| `BigPiConsole` | Console application — computes and prints Pi digits |
| `BigPiFMX` | FireMonkey GUI — displays Pi digits as they are computed |
| `Tests/BigPiTests` | DUnitX test suite — validates algorithm correctness |

Open `BigPiGroup.groupproj` in Delphi to work with all projects together.

## Requirements

- Delphi (tested with recent versions supporting generics and anonymous methods)
- RudysBigNumbers submodule (included at `lib/RudysBigNumbers`)

After cloning, initialize the submodule:
```bash
git submodule update --init
```

## License

Licensed under the [GNU General Public License v3.0 (GPLv3)](LICENSE).

Uses [Rudy's Big Numbers Library](https://github.com/TurboPack/RudysBigNumbers) (BSD 2-Clause).

## Contributors

See [CONTRIBUTORS.md](CONTRIBUTORS.md).
