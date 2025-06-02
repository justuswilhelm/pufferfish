---
title: How to set up wireguard
---

Create `wg0.conf`:

```
[Interface]
PrivateKey = XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
Address = 172.0.0.1/24
ListenPort = 51820

[Peer]
PublicKey = XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
Endpoint = XX.XX.XXX.XXX:51820
AllowedIPs = 0.0.0.0/0
```


```bash
sudo wg-quick up $PWD/wg0.conf
```
