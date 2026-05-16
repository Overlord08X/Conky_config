# conky-altcoin-monitor

Deskripsi: Menampilkan harga mata uang kripto menggunakan Coingecko API.

Dependencies:
- `conky`
- `curl`
- `jq`

Usage:

1. Pastikan dependensi terpasang.
2. Jalankan `fetch.sh` secara manual atau biarkan conky memanggilnya:

```bash
bash conf/conky-altcoin-monitor/fetch.sh
conky -c ~/.config/conky/conf/conky-altcoin-monitor/conky-altcoin-monitor &
```

Catatan:
- `fetch.sh` mengambil data dari Coingecko dan memprosesnya dengan `jq`.
