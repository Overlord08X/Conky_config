# conky-weather

Deskripsi: Menampilkan cuaca menggunakan `wttr.in` dan/atau skrip `weather-pull.sh`.

Dependencies:
- `conky`
- `curl`

Usage:

```bash
bash conf/conky-weather/weather-pull.sh
conky -c ~/.config/conky/conf/conky-weather/conky-weather &
```

Catatan: `weather-pull.sh` menulis data sementara ke `/tmp`.
