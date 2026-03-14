# Delphi Big Pi

**Computing Pi in Delphi** — A collection of projects featuring both BBP and Chudnovsky algorithms for computing digits of Pi, powered by [Rudy's Big Numbers Library](https://github.com/TurboPack/RudysBigNumbers).

## Overview

Delphi Big Pi demonstrates high-precision computation of Pi using:

- **[BBP (Bailey–Borwein–Plouffe)](https://en.wikipedia.org/wiki/Bailey%E2%80%93Borwein%E2%80%93Plouffe_formula)** — An integer based _spigot_ algorythm that computes individual hexadecimal digits of Pi without computing preceding digits
- **[Chudnovsky](https://en.wikipedia.org/wiki/Chudnovsky_algorithm)** — A a floating point based rapidly converging series for computing Pi to arbitrary precision

Both algorithms use RudysBigNumbers for arbitrary-precision arithmetic.

## Projects

| Project            | Description                                               |
| ------------------ | --------------------------------------------------------- |
| `src\BigPiConsole` | Console application — computes and prints Pi digits       |
| `src\BigPiFMX`     | Displays Pi digits as they are computed on _any_ platform |
| `Tests/BigPiTests` | DUnitX test suite — validates algorithm correctness       |

Open `BigPiGroup.groupproj` in Delphi to work with all projects together.

## Requirements

- Delphi (tested with recent versions supporting generics and anonymous methods)
- Rudy's Big Numbers library (included at `lib/RudysBigNumbers`)
  - After cloning, initialize the submodule:

    ```bash
     git submodule update --init
    ```

Or point the projects to an existing installation of [Rudy's Big Numbers](https://github.com/TurboPack/RudysBigNumbers) library.

## License

Licensed under the [GNU General Public License v3.0 (GPLv3)](LICENSE).

Uses [Rudy's Big Numbers Library](https://github.com/TurboPack/RudysBigNumbers) (BSD 2-Clause).

## Contributors

Thanks to the late [Rudy Velthuis](https://github.com/rvelthuis) for his Big Number Libraries, [Tommi Prami](https://github.com/TommiPrami), and everyone who helps maintain [TurboPack](https://github.com/TurboPack).
