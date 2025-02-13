[![Automatic version updates](https://github.com/ZOSOpenTools/perlport/actions/workflows/bump.yml/badge.svg)](https://github.com/ZOSOpenTools/perlport/actions/workflows/bump.yml)

# Perl

The perl programming language

# Installation and Usage

Use the zopen package manager ([QuickStart Guide](https://zopen.community/#/Guides/QuickStart)) to install:
```bash
zopen install perl
```

# Building from Source

1. Clone the repository:
```bash
git clone https://github.com/zopencommunity/perlport.git
cd perlport
```
2. Build using zopen:
```bash
zopen build -vv
```

See the [zopen porting guide](https://zopen.community/#/Guides/Porting) for more details.

# Documentation

# Setting Up CPAN

To install Perl modules using cpan, you need to configure it to use the zopen tools.

If cpan is not properly configured, it may not function correctly. Follow these steps to set it up:

## Prerequisites
Before setting up CPAN, ensure the following tools are installed via `zopen`:

- `wget`
- `curl`
- `tar`
- `make`
- `gzip`
- `bzip2`

You can install them using:
```sh
zopen install curl wget tar make gzip bzip2
```

## Configuring CPAN

### 1. Initialize CPAN
Run the following command to enter the CPAN shell:
```sh
cpan
```
If this is the first time running CPAN, it will prompt for initial configuration. You can choose automatic configuration (press enter) unless you need custom settings.

If the current CPAN configuration is incorrect, reset it using:
```sh
rm -rf ~/.cpan
cpan
```

### 2. Set Up CPAN Configuration
If `cpan` detects the z/OS version of make and tar and fails the initial setup, then you can configure it to pick up the zopen tools with the following:
```sh
cpan
o conf make /path/to/zopen/make
o conf tar /path/to/zopen/tar
# do the same for wget, gzip, and others as needed...
o conf commit
```
Verify that the ` ~/.cpan/CPAN/MyConfig.pm` file is updated accordingly by viewing it.

### 3. Install Required Modules
Once CPAN is set up, install Perl modules as needed:
```sh
cpan install Switch
```

## Troubleshooting
- If CPAN fails due to missing dependencies, verify that `wget`, `tar`, `make`, `gzip`, and `bzip2` are properly installed and referenced in the `~/.cpan/CPAN/MyConfig.pm` file.
- If CPAN configuration is incorrect, reset it using:
  ```sh
  rm -rf ~/.cpan
  ```
  Then re-run `cpan` to reconfigure.

## Troubleshooting
TBD

## Contributing
Contributions are welcome! Please follow the [zopen contribution guidelines](https://github.com/zopencommunity/meta/blob/main/CONTRIBUTING.md).
