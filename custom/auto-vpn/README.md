# auto vpn

setup your own vpn using [hwdsl2/setup-ipsec-vpn](https://github.com/hwdsl2/setup-ipsec-vpn) project and various custom backend providers, digital ocean only for now.

## usage

setup vars.sh with your credentials/variables and run

```./deploy.sh create```

in the end you will see screen like below, and question about password for sudo (to update record in /etc/hosts).

```
...
IPsec VPN server is now ready for use!
Connect to your new VPN with these details:

Server IP: 192.141.124.67
IPsec PSK: vBvvrefSDSvsga
Username: d47zm3
Password: vwqert@fvw2s
...
[21:00:26] server setup succesfully! update/create local dns record "167.99.219.142 vpn.server" in /etc/hosts
[21:00:27] record found, update...
Password:
```

setup VPN connection in your system according to this [document](https://github.com/hwdsl2/setup-ipsec-vpn/blob/master/docs/clients.md) while giving as server name local dns record, **vpn.server**, everything takes about 5 minutes, to destroy server issue

```./deploy.sh destroy```


## prerequisites

for digital ocean, you need to add your public ssh key under security tab in your account or you won't be able to create droplet with your ssh key.
