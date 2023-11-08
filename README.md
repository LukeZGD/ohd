# ohd

Offsets for Home Depot 8.x A5(X)

```
Home Depot 8.4.1 patch to 8.x
replaces: wall.supplies/offsets
with:     lukezgd.github.io/ohd

printf '\x6C\x75\x6B\x65\x7A\x67\x64\x2E\x67\x69\x74\x68\x75\x62\x2E\x69\x6F\x2F\x6F\x68\x64' | dd of='Payload/Home Depot.app/Home Depot' bs=1 seek=486669 count=20 conv=notrunc
```
