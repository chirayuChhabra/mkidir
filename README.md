# mkidir

Atomic devbox environment bootstrapper.

`mkidir` creates a development environment in an isolated sandbox
and commits it atomically to the filesystem.

## Features

- Atomic environment creation
- Automatic devbox initialization
- Batch package installation
- Automatic git initialization if `git` package is detected
- Dry run mode
- Safe rollback on failure

## Installation

Clone the repo and place `mkidir` in your PATH.

Example:

cp mkidir /usr/local/bin/mkidir

## Usage

mkidir <target_path> [packages...] [--dry-run]

Example:

mkidir dev/backend/api nodejs@24 bun git
