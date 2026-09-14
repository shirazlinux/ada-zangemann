# Ada & Zangemann on Paasta

Static nginx image of this site for [Paasta](https://console.paasta.cloud) (neda1).
Public HTTP is port **8080**.

## Live

- URL: https://ada.fsfp.ir
- Fallback: https://ada.neda1.paasta.app
- Plan: `basic` (payg)

## Deploy

```bash
cd ~/Documents/github/ada-zangemann
paasta deploy . -n ada -p basic --billing payg --yes
paasta domain add ada ada.fsfp.ir
paasta monitor set ada --enabled true --path /health --failures 3 --yes
```

Stop billing: `paasta stop ada` or `paasta delete ada --yes`.

## Local test

```bash
cd ~/Documents/github/ada-zangemann
docker compose up -d --build
curl -fsS http://127.0.0.1:18080/health
# open http://127.0.0.1:18080/
```
