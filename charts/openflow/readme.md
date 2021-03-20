# Helm repo
#### Quick start using helm to install on kubernetes

To quickly get started with your own installation on kubernetes, first install [traefik](https://doc.traefik.io/traefik/v1.7/user-guide/kubernetes/)

Each OpenFlow will have it's own namespace, and you create a value file for each instance/namespace
Create a file and call it demo1.yaml with this content

```yaml
# this will be the root domain name hence your openflow url will now be http://demo.mydomain.com 
domainsuffix: mydomain.com # this will be added to all domain names
domain: demo 
# if using a reverse procy that add ssl, uncomment below line.
# protocol: https
openflow:
#  external_mongodb_url: mongodb+srv://user:pass@cluster0.gcp.mongodb.net?retryWrites=true&w=majority
rabbitmq:
  default_pass: supersecret
# if you are using mpongodb atlas, or has mongodb running somewhere else
# uncomment below line, and external_mongodb_url in openflow above
# mongodb:
#   enabled: false
```

First add the helm repo and  create a new namespace called demo1

``` sh
helm repo add openiap https://open-rpa.github.io/helm-charts/
helm repo update
kubectl create namespace demo1
```

The create the install using 

```sh
helm install openflow openiap/openflow -n demo1 --values ./demo1.yaml
```

If you late update your values file you can update your install using 

```sh
helm upgrade openflow openiap/openflow -n demo1 --values ./demo1.yaml
```

To learn more about values you can use in your values file, have a look inside [values.yaml](https://raw.githubusercontent.com/open-rpa/helm-repo/main/values.yaml) 

