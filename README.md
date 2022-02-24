# Start

```
docker-compose up --build -d
```

The application runs on [http://localhost:8080](http://localhost:8080).

# Stop

```
docker-compose down
```

# Extract certificates

```
host=pypi.org port=443; echo | \
    openssl s_client -connect "${host}":"${port}" -showcerts 2>/dev/null | \
    sed -n -e '/-.BEGIN/,/-.END/ p' > cert_pip.pem
```

```
host=conda.anaconda.org port=443; echo | \
    openssl s_client -connect "${host}":"${port}" -showcerts 2>/dev/null | \
    sed -n -e '/-.BEGIN/,/-.END/ p' > cert_conda.pem
```

Manualy add the root ca cert to the top of the resulting file. 

Pypi: Visit [GlobalSign](https://support.globalsign.com/ca-certificates/root-certificates/globalsign-root-certificates)
to get the GlobalSign Root CA certificates (click 'View in Base64' to get it in PEM format).

Conda: Visit [DigiCert](https://www.digicert.com/kb/digicert-root-certificates.htm)
to get the GlobalSign Root CA certificates (click 'View in Base64' to get it in PEM format).