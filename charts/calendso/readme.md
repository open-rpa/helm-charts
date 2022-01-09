# Helm repo
#### Quick start using helm to install on calendso

First add the helm repo and  create a new namespace called demo1

``` sh
helm repo add openiap https://open-rpa.github.io/helm-charts/
helm repo update
kubectl create namespace calendso
```

Create a value file for your instance/namespace
Create a file and call it calendso.yaml with this content
please replace localhost.openiap.io with your domain name
```yaml
domain: cal.localhost.openiap.io
port: 443
protocol: https
license: agree
prisma:
  enabled: true
  domain: prisma.localhost.openiap.io
postgresql:
  enabled: true
  postgresqlPassword: super_secret_password
  postgresqlUsername: unicorn_admin
  postgresqlDatabase: calendso
```
The create the install using 

```sh
helm install calendso openiap/calendso -n calendso --values ./calendso.yaml
```

Go to http://prisma.localhost.openiap.io
Click on the User model to add a new user record
Fill out the fields (remembering to encrypt your password with [BCrypt](https://bcrypt-generator.com/)) and click Save 1 Record to create your first user.
( set metadata to {} )

Then update your values file to set prisma.enabled: false and update your installation
```sh
helm upgrade calendso openiap/calendso -n calendso --values ./calendso.yaml
```

now you can access http://cal.localhost.openiap.io

If using traefik as ingress controller and you have letsencrypt configured,
you can enable certificates for all ingress controllers ( see https://github.com/open-rpa/helm-charts/blob/main/charts/openflow/values.yaml for more information )
and then update port to 443 and protocol to https 
