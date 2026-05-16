# conky-mini-playerctl

Deskripsi: Menampilkan cover, judul, dan artis dari pemutar media via MPRIS (`playerctl`).

Dependencies:
- `conky`
- `playerctl`
- `curl` (digunakan untuk mengambil thumbnail eksternal)
- `python3` (dipakai untuk enkoding query pada fallback iTunes API)

Usage:

```bash
bash conf/conky-mini-playerctl/get-cover.sh
conky -c ~/.config/conky/conf/conky-mini-playerctl/conky-mini-playerctl &
```

Catatan:
- `get-cover.sh` akan membuat `/tmp/conky-cover.png` yang kemudian dimuat oleh Conky.
- Pemutar harus mendukung MPRIS (mis. Spotify, VLC, mpv).
