<!--
SPDX-FileCopyrightText: 2014-2025 Justus Perlwitz

SPDX-License-Identifier: GPL-3.0-or-later
-->

---
title: Using garage for storing things
---

<https://garagehq.deuxfleurs.fr/documentation/quick-start/>
<https://docs.fluentd.org/output/s3>

Show the status:

```bash
sudo garage status
```

Run locally with just one node, this command shows the following:

```
==== HEALTHY NODES ====
ID                Hostname  Address         Tags  Zone  Capacity          DataAvail
XXXXXXXXXXXXXXXX  nitrogen  127.0.0.1:3901              NO ROLE ASSIGNED
```

Create and review the basic layout from the quickstart tutorial using the following two commands:

```bash
sudo garage layout assign -z dc1 -c 1G XXXXXXXXXXXXXXXX
sudo garage layout show
```

The first commands prints:

```
Role changes are staged but not yet commited.
Use `garage layout show` to view staged role changes,
and `garage layout apply` to enact staged changes.
```

The second command prints:

```
==== CURRENT CLUSTER LAYOUT ====
No nodes currently have a role in the cluster.
See `garage status` to view available nodes.

Current cluster layout version: 0

==== STAGED ROLE CHANGES ====
ID                Tags  Zone  Capacity
XXXXXXXXXXXXXXXX        dc1   1000.0 MB


==== NEW CLUSTER LAYOUT AFTER APPLYING CHANGES ====
ID                Tags  Zone  Capacity   Usable capacity
XXXXXXXXXXXXXXXX        dc1   1000.0 MB  1000.0 MB (100.0%)

Zone redundancy: maximum

==== COMPUTATION OF A NEW PARTITION ASSIGNATION ====

Partitions are replicated 1 times on at least 1 distinct zones.

Optimal partition size:                     3.9 MB
Usable capacity / total cluster capacity:   1000.0 MB / 1000.0 MB (100.0 %)
Effective capacity (replication factor 1):  1000.0 MB

dc1                 Tags  Partitions        Capacity   Usable capacity
  XXXXXXXXXXXXXXXX        256 (256 new)     1000.0 MB  1000.0 MB (100.0%)
  TOTAL                   256 (256 unique)  1000.0 MB  1000.0 MB (100.0%)


To enact the staged role changes, type:

    garage layout apply --version 1

You can also revert all proposed changes with: garage layout revert
```

Apply the layout:

```bash
sudo garage layout apply --version 1
```

I want to store my fluentd logs in garage and use the following commands:

```bash
sudo garage bucket create fluentd
sudo garage gucket list
```

```
Bucket fluentd was created.

List of buckets:
  fluentd    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

Bucket: XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

Size: 0 B (0 B)
Objects: 0
Unfinished uploads (multipart and non-multipart): 0
Unfinished multipart uploads: 0
Size of unfinished multipart uploads: 0 B (0 B)

Website access: false

Global aliases:
  fluentd

Key-specific aliases:

Authorized keys:
```

Create a key for fluentd:

```bash
sudo garage key create fluentd-key
sudo garage bucket allow \
  --read \
  --write \
  --owner \
  fluentd \
  --key fluentd-key
```

This prints the following:

```
Key name: fluentd-key
Key ID: XXXXXXXXXXXXXXXXXXXXXXXXXX
Secret key: XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
Can create buckets: false

Key-specific bucket aliases:

Authorized buckets:
New permissions for XXXXXXXXXXXXXXXXXXXXXXXXXX on fluentd: read true, write true, owner true.
```

The fluentd output config should look something like this:

```
<match pattern>
  @type s3

  aws_key_id XXXXXXXXXXXXXXXXXXXXXXXXXX
  aws_sec_key XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  s3_bucket fluentd
  s3_endpoint 127.0.0.1:3900
  path logs/
  <buffer tag,time>
    @type file
    path /var/log/fluent/s3
    timekey 3600 # 1 hour partition
    timekey_wait 10m
    timekey_use_utc true # use utc
    chunk_limit_size 256m
  </buffer>
</match>
```
