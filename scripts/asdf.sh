#!/bin/bash

# install node
command asdf -v >/dev/null 2>&1 \
  && asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git \
  && asdf install nodejs latest \
  && asdf global nodejs latest

# install java
command asdf -v >/dev/null 2>&1 \
  && asdf plugin add java https://github.com/halcyon/asdf-java.git \
  && asdf install java latest:adoptopenjdk \
  && asdf global java latest:adoptopenjdk

# install golang
command asdf -v >/dev/null 2>&1 \
  && asdf plugin add golang https://github.com/kennyp/asdf-golang.git \
  && asdf install golang latest \
  && asdf global golang latest

# install rust
command asdf -v >/dev/null 2>&1 \
  && asdf plugin add rust https://github.com/code-lever/asdf-rust.git \
  && asdf install rust latest \
  && asdf global rust latest
