# alma-wsl

Dotfiles for AlmaLinux running on WSL (Windows). Lean zsh setup focused on daily DevOps work — git, docker, kubernetes, terraform.

## Layout

| File | Purpose |
|------|---------|
| `bootstrap.sh`  | Installs dnf packages, oh-my-zsh, plugins, powerlevel10k, links `~/.zshrc`, chsh to zsh. |
| `.zshrc`        | Zsh entry point. Symlinked to `~/.zshrc`. |
| `aliases.zsh`   | Shortcut aliases (git, docker, k8s, tf, system). |
| `functions.zsh` | Multi-line shell functions (`mkcd`, `extract`, `portkill`, `gacp`, `klogs`, ...). |

## Install

From inside the dotfiles repo:

```bash
./alma-wsl/bootstrap.sh
```

Then start a new WSL session (or `exec zsh`). First zsh launch will run `p10k configure` for the prompt — or skip it and run later.

## Common shortcuts

### Git
| Alias | Command |
|-------|---------|
| `gs`   | `git status` |
| `gp`   | `git pull` |
| `gps`  | `git push` |
| `gpsu` | `git push -u origin HEAD` |
| `gco`  | `git checkout` |
| `gcob` | `git checkout -b` |
| `gcm`  | `git commit -m` |
| `gd`   | `git diff` |
| `gl`   | `git log --oneline -15` |
| `gll`  | pretty graph log |
| `gst`  | `git stash` |
| `gf`   | `git fetch --all --prune` |
| `gacp <msg>` | add all + commit + push |
| `gpsup`      | push current branch with `-u` |

### Docker
| Alias | Command |
|-------|---------|
| `d`     | `docker` |
| `dps`   | `docker ps` |
| `drm`   | `docker rm` |
| `drmi`  | `docker rmi` |
| `drmf`  | `docker rm -f` |
| `dprune` | `docker system prune -af` |
| `dex`   | `docker exec -it` |
| `dlog`  | `docker logs -f` |
| `dc`    | `docker compose` |
| `dcu`   | `docker compose up -d` |
| `dcd`   | `docker compose down` |
| `dcl`   | `docker compose logs -f` |

### Kubernetes
| Alias | Command |
|-------|---------|
| `k`    | `kubectl` |
| `kgp`  | `kubectl get pods` |
| `kgpa` | `kubectl get pods -A` |
| `kaf`  | `kubectl apply -f` |
| `kl`   | `kubectl logs -f` |
| `kex`  | `kubectl exec -it` |
| `kctx` | kubectx (or `kubectl config get-contexts`) |
| `klogs <pod> [ns]` | tail all containers of a pod |
| `ksh   <pod> [ns]` | exec into a pod (bash, fall back to sh) |

### Terraform
| Alias | Command |
|-------|---------|
| `tf`   | `terraform` |
| `tfi`  | `terraform init` |
| `tfp`  | `terraform plan` |
| `tfa`  | `terraform apply` |
| `tfaa` | `terraform apply -auto-approve` |
| `tff`  | `terraform fmt -recursive` |

### WSL bits
| Alias | What it does |
|-------|--------------|
| `explorer`         | open current dir in Windows Explorer |
| `cdwin`            | jump to `/mnt/c/Users/$USER` |
| `pbcopy` / `pbpaste` | clipboard via `clip.exe` / PowerShell |

### System
| Alias | Command |
|-------|---------|
| `ll`  | `ls -lah` |
| `..`, `...`, `....` | `cd` up 1/2/3 levels |
| `ports`  | `ss -tulpn` |
| `myip`   | external IP via ifconfig.me |
| `sysinfo` | one-line OS/kernel/shell/mem/disk |
| `portkill <port>` | kill listener on a port |

## Local-only overrides

Drop machine-specific tweaks (work creds, project paths) into `~/.zshrc.local` — it's sourced if present and never committed.
