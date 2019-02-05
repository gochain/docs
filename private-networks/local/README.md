# Local Ephemeral Suite

This directory contains a `docker-compose` file for running an ephemeral development suite consisting of:

 - [gochain/gochain](https://github.com/gochain-io/gochain)
 - [gochain/netstats](https://github.com/gochain-io/netstats)
 - [gochain/rpc-proxy](https://github.com/gochain-io/rpc-proxy)
 - [gochain/explorer](https://github.com/gochain-io/explorer)

The `latest` tagged images are used by default. You may override with a different tag via an `.env` file:
```
GOCHAIN_IMAGE=stable
NETSTATS_IMAGE=my_custom_image
```

## Running & Monitoring

- Start: `docker-compose up -d`
- Stop: `docker-compose down`
- Follow Logs: `docker logs -f --tail 100 node`
- Restart Container: `docker-compose restart node`
- Restart All: `docker-compose down && docker-compose up -d`
- Attach Console: `docker exec -it node gochain --datadir /tmp attach`

## Web Interfaces

- Netstats: http://localhost:80
- Explorer: http://localhost:8000
- RPC Proxy: http://localhost:8080
