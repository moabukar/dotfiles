# 📚 DevOps Aliases Reference

Complete reference for all available aliases and functions.

> **Tip:** Type `aliases` in your terminal for a quick overview.

## 🔹 General

```bash
ll        # ls -alF
la        # ls -A
..        # cd ..
...       # cd ../..
....      # cd ../../..
c         # clear
h         # history
```

## 🔹 Git

### Basic Operations
```bash
g         # git
gs        # git status
ga        # git add
gaa       # git add --all
gc        # git commit
gcm       # git commit -m "message"
gp        # git push
gpl       # git pull
gf        # git fetch
```

### Branches
```bash
gb        # git branch
gba       # git branch -a
gco       # git checkout
gcb       # git checkout -b
```

### Viewing History
```bash
gl        # git log --oneline -n 20
glog      # git log --graph --oneline --decorate
gd        # git diff
gds       # git diff --staged
```

### Advanced
```bash
grh       # git reset --hard
grs       # git reset --soft
gst       # git stash
gstp      # git stash pop
gcp       # git cherry-pick
gm        # git merge
gr        # git rebase
```

### Quick Workflows
```bash
gacp      # git add --all && git commit -m
gcap MSG  # git add all, commit, push (one command!)
```

## 🐳 Docker

### Basic
```bash
d         # docker
dc        # docker compose
dps       # docker ps
dpsa      # docker ps -a
di        # docker images
drm       # docker rm
drmi      # docker rmi
```

### Execute & Logs
```bash
dex       # docker exec -it
dlogs     # docker logs -f
dsh       # docker exec -it <container> /bin/sh
dbash     # docker exec -it <container> /bin/bash
```

### Cleanup
```bash
dprune    # docker system prune -af
dvprune   # docker volume prune -f
dstop     # stop all running containers
dkill     # kill all running containers
drmall    # remove all containers
drmiall   # remove all images
```

### Utilities
```bash
drun      # docker run -it --rm
dbuild    # docker build -t <tag> .
dstats    # docker stats (formatted)
```

## ☸️ Kubernetes

### Context & Namespace
```bash
k         # kubectl
kx        # kubectx (switch context)
kn        # kubens (switch namespace)
kcgc      # kubectl config get-contexts
kcuc      # kubectl config use-context
kccc      # kubectl config current-context
kcns      # kubectl config set-context --current --namespace
```

### Get Resources
```bash
kg        # kubectl get
kgp       # kubectl get pods
kgpa      # kubectl get pods -A
kgpw      # kubectl get pods -o wide
kgs       # kubectl get svc
kgsa      # kubectl get svc -A
kgd       # kubectl get deployments
kgda      # kubectl get deployments -A
kgn       # kubectl get nodes
kgnw      # kubectl get nodes -o wide
kgns      # kubectl get namespaces
kgi       # kubectl get ingress
kgia      # kubectl get ingress -A
kgcm      # kubectl get configmap
kgsec     # kubectl get secrets
kgpv      # kubectl get pv
kgpvc     # kubectl get pvc
kgall     # kubectl get all
kgalla    # kubectl get all -A
kgev      # kubectl get events --sort-by=.lastTimestamp
```

### Describe
```bash
kd        # kubectl describe
kdp       # kubectl describe pod
kds       # kubectl describe svc
kdd       # kubectl describe deployment
kdn       # kubectl describe node
kdi       # kubectl describe ingress
```

### Delete
```bash
kdel      # kubectl delete
kdelp     # kubectl delete pod
kdels     # kubectl delete svc
kdeld     # kubectl delete deployment
kdelf     # kubectl delete -f
```

### Logs
```bash
kl        # kubectl logs
klf       # kubectl logs -f
klt       # kubectl logs --tail=100
klft      # kubectl logs -f --tail=100
klp       # kubectl logs -p (previous)
```

### Exec
```bash
kex       # kubectl exec -it
ksh       # kubectl exec -it <pod> -- /bin/sh
kbash     # kubectl exec -it <pod> -- /bin/bash
```

### Apply/Delete Manifests
```bash
ka        # kubectl apply -f
kaf       # kubectl apply -f
kdf       # kubectl delete -f
kak       # kubectl apply -k (kustomize)
```

### Port Forwarding
```bash
kpf       # kubectl port-forward <pod> <port>
```

### Scaling & Rollouts
```bash
kscale    # kubectl scale deployment <name> --replicas=<n>
krestart  # kubectl rollout restart deployment <name>
krs       # kubectl rollout status deployment <name>
```

### Watch
```bash
kwp       # watch kubectl get pods
kwpa      # watch kubectl get pods -A
kwn       # watch kubectl get nodes
```

### Search & Utilities
```bash
kgpn      # get pod by partial name
kln       # logs by partial pod name (follows)
kexn      # exec into pod by partial name
ksecdec   # decode secret value
ksecshow  # show all decoded secrets
kdebug    # run temporary alpine debug pod
```

## ⛵ Helm

```bash
hls       # helm list
hlsa      # helm list -A
hi        # helm install
hu        # helm upgrade
hui       # helm upgrade --install
hd        # helm delete
hun       # helm uninstall
hs        # helm status
hh        # helm history
hr        # helm rollback
hrepo     # helm repo
hrepou    # helm repo update
hrepoa    # helm repo add
hrepol    # helm repo list
hsearch   # helm search repo
hshow     # helm show values
hget      # helm get values
hgeta     # helm get all
hdry      # helm install --dry-run --debug
ht        # helm template
```

## 🏗️ Terraform

### Basic
```bash
tf        # terraform
tfi       # terraform init
tfiu      # terraform init -upgrade
tfp       # terraform plan
tfa       # terraform apply
tfaa      # terraform apply -auto-approve
tfd       # terraform destroy
tfda      # terraform destroy -auto-approve
tff       # terraform fmt
tffr      # terraform fmt -recursive
tfv       # terraform validate
```

### State Management
```bash
tfs       # terraform state
tfsl      # terraform state list
tfss      # terraform state show
tfsm      # terraform state mv
tfsr      # terraform state rm
```

### Outputs & Workspaces
```bash
tfo       # terraform output
tfoj      # terraform output -json
tfw       # terraform workspace
tfwl      # terraform workspace list
tfws      # terraform workspace select
tfwn      # terraform workspace new
tfwd      # terraform workspace delete
```

### Advanced
```bash
tfr       # terraform refresh
tfim      # terraform import
tfc       # terraform console
tfg       # terraform graph
tfpo      # terraform plan -out=<file>
tfap      # terraform apply <plan-file>
tfpt      # terraform plan -target=<resource>
tfat      # terraform apply -target=<resource>
```

## ☁️ AWS

### Identity & Configuration
```bash
awsid     # aws sts get-caller-identity
awswho    # aws sts get-caller-identity
awsregion # aws configure get region
awsprofile # echo $AWS_PROFILE
awsregions # list all AWS regions
awsp      # set AWS_PROFILE
awsr      # set AWS_DEFAULT_REGION
```

### EC2
```bash
ec2ls       # list all instances
ec2running  # list running instances
ec2stop     # stop instance
ec2start    # start instance
ec2terminate # terminate instance
```

### S3
```bash
s3ls      # aws s3 ls
s3mb      # aws s3 mb (make bucket)
s3rb      # aws s3 rb (remove bucket)
s3cp      # aws s3 cp
s3mv      # aws s3 mv
s3rm      # aws s3 rm
s3sync    # aws s3 sync
```

### EKS
```bash
eksls     # list clusters
eksupdate # update kubeconfig for cluster
eksdesc   # describe cluster
```

### ECR
```bash
ecrlogin  # docker login to ECR
ecrls     # list repositories
```

### Lambda
```bash
lambdals     # list functions
lambdainvoke # invoke function
```

### CloudFormation
```bash
cfnls     # list stacks
cfndesc   # describe stack
cfnevents # describe stack events
```

### IAM
```bash
iamuser   # get current user
iamusers  # list users
iamroles  # list roles
```

### CloudWatch Logs
```bash
cwlogs    # list log groups
cwtail    # tail logs
```

## 🛠️ Utilities

### File & Directory
```bash
mkcd      # mkdir and cd into it
ff        # find file by name
fd        # find directory by name
fg        # find and grep
gr        # grep recursively
extract   # extract any archive (tar, zip, etc.)
```

### Network
```bash
myip      # get public IP
localip   # get local IP
serve     # start HTTP server (default port 8000)
ports     # show listening ports
killport  # kill process on specific port
```

### Encoding/Decoding
```bash
b64e      # base64 encode
b64d      # base64 decode
urlencode # URL encode
urldecode # URL decode
json      # pretty print JSON
jsonclip  # pretty print JSON from clipboard
```

### Generation
```bash
genpass   # generate random password
genuuid   # generate UUID
timestamp # generate timestamp (YYYYMMDDHHMMSS)
datestamp # generate datestamp (YYYY-MM-DD)
now       # current date and time
```

### System Info
```bash
path      # show PATH entries (one per line)
dirsize   # size of current directory
dirsizes  # size of all subdirectories (sorted)
largef    # find large files (>100M by default)
df        # disk usage (human readable)
du        # directory usage (human readable)
free      # memory usage (human readable)
psg       # ps aux | grep (search processes)
```

### Fun Stuff
```bash
weather   # get weather report
cheat     # get cheat sheet for command
```

---

**Full implementation:** `~/.dotfiles/shell/aliases.sh`

**Add your own:** Edit `shell/aliases.sh` and add custom aliases
