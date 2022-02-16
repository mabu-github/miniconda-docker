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
    sed -n -e '/-.BEGIN/,/-.END/ p' > cert.pem
```

Manualy add the root ca cert to the top of the resulting file. Visit [GlobalSign](https://support.globalsign.com/ca-certificates/root-certificates/globalsign-root-certificates)
to get the GlobalSign Root CA certificates (click 'View in Base64' to get it in PEM format).