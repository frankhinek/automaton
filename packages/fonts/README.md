# Licensed Fonts

Private repository storing fonts I've previously purchased.

This repo is primarily used to facilitate automated system setup with [automaton](https://github.com/frankhinek/automaton.git).

## Patching MonoLisa with [NerdFonts](https://www.nerdfonts.com/)

### TEMPORARY: Custom Build NerdFonts Patcher Container

_Note_: This section can be deleted once a new `nerdfonts/patcher` Docker image has been published.  I submitted [PR #882](https://github.com/ryanoasis/nerd-fonts/pull/882) to the NerdFonts repo to try and get Docker builds to stop failing.

Due issues with how backticks are improperly displayed (See [#858](https://github.com/ryanoasis/nerd-fonts/issues/858) and [#860](https://github.com/ryanoasis/nerd-fonts/pull/860)), a custom Docker container for the NerdFonts patcher must be built locally before proceeding with the steps.

This won't be necessary at some point, but for the moment, a new Docker container [hasn't been published](https://hub.docker.com/r/nerdfonts/patcher) by NerdFonts in 8 months.  It appears the `Push image` GitHub action is failing as [seen here](https://github.com/ryanoasis/nerd-fonts/runs/7895425759?check_suite_focus=true) after commit [3234fe0](https://github.com/ryanoasis/nerd-fonts/commit/3234fe0caff2fcd308844176b8f845a61a06e764).  Upon investigation, it appears the issue is that the NerdFonts [Dockerfile](https://github.com/ryanoasis/nerd-fonts/blob/master/Dockerfile) attemps to install the `fontforge` package from the Alpine Linux `testing` branch but the only architecture with a package in that branch is `riscv64`.  The [`community` branch](https://pkgs.alpinelinux.org/packages?name=fontforge&branch=edge&repo=&arch=&maintainer=) does contain images for multiple architectures, so the proposed fix is to install the package from `community`.

Clone the `nerdfonts/patcher` repository to your local workstation:

```console
git clone https://github.com/ryanoasis/nerd-fonts
```

Edit the `Dockerfile` so that the `RUN` command reads:

```dockerfile
RUN apk update && apk upgrade && apk add --no-cache fontforge --repository=https://dl-cdn.alpinelinux.org/alpine/edge/community && \
    apk add --no-cache py3-pip && \
    pip install configparser
```

Build the Docker container image:

```console
docker build -t nerdfonts/patcher .
```

### TEMPORARY: Proceed with original steps

Clone this repo:

```console
git clone https://github.com/frankhinek/fonts-licensed
```

Use a NerdFonts-provided Docker container to patch all of the MonoLisa TrueType font files:

```console
cd fonts-licensed/MonoLisa-Plus/v2.000
docker run -v $PWD/ttf:/in -v $PWD/ttf-nerd-font:/out nerdfonts/patcher --complete
```

Rename the font files to match the PostScript names:
```fish
for file in ttf-nerd-font/*.ttf
    set newfile (string replace -a ' Complete' '' $file)
    set newfile (string replace -a ' Nerd Font' '' $newfile)
    set newfile (string replace -a 'MonoLisa' 'MonoLisa Nerd Font' $newfile)
    mv -v -- "$file" "$newfile"
end
```

Reference: https://github.com/MonoLisaFont/feedback/issues/57