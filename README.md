# Notification Services



## Detalhes de Extração do Certificado

### Extract cert PFX:
openssl pkcs12 -in notify.pensepneus.com.br.pfx -clcerts -nokeys -out cert.crt

### Extract Key PFX:
openssl pkcs12 -in notify.pensepneus.com.br.pfx -nocerts -out pk.key

### Decrypt Key PFX(RSA):
openssl rsa -in pk.key -out decrypted-pk.key

### Renewing
wacs.exe --renew --baseuri "https://acme-v02.api.letsencrypt.org/"

### Extract Key PEM
openssl pkey -in notify.pensepneus.com.br-key.pem -out privatekey.key

### Extract Cert PEM:
openssl x509 -in yourfile.pem -out certificate.crt

### Show All Certificates in a PEM

while openssl x509 -noout -text; do :; done < fullchain.pem