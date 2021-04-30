# Traefik example files for using traefik in google clode, with dns hosted at google cloud

First create a service account, and make the service account dns admin and is created in the same project as DNS is in
Open the service account, go to keys and create new key, using json
Add the content of the json file to traefik-config.yaml under account.json

Create a IP for traefik VPC Network -> External IP addresses.
Click "reserve static address" and leave everyting deafult, but select the same region as your kubernetes cluster
Wait for the IP to appear in the list, then copy it
I like to add an DNS record for this IP as traefik.domain.com so i can use CNAME's for this domain

Open traefik.yaml and 
update loadBalancerIP to the IP you reserved above
update GCE_PROJECT to the project you create the service account in
update certificatesresolvers.default.acme.email to your email

Make sure helm is installed [installed](https://helm.sh/docs/using_helm/#installing-helm)
Add Traefik's chart repository to Helm:

```bash
helm repo add traefik https://helm.traefik.io/traefik
```
Create a namespace for traefik
```bash
kubectl create namespace traefik
```
then install traefik with your values files
```bash
helm install traefik traefik/traefik --namespace=traefik --values=.\traefik-example\traefik.yaml
```

If you also want the dashboard ( set dashboard.enabled to true in traefik.yaml )
create a CNAME pointing to traefik.domain.com
Open dashboard.yaml and edit the domain to match your traefik.domain.com
then add the IngressRoute for the dashboard
```bash
kubectl apply -f .\traefik-example\dashboard.yaml
```
