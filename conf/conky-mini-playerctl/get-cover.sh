#!/bin/bash
COVER="/tmp/conky-cover.png"
LAST_INFO="/tmp/conky-last-info"
DEFAULT="$HOME/.config/conky/conf/conky-mini-playerctl/default-cover.png"

# Cek apakah ada player aktif
PLAYERS=$(playerctl -l 2>/dev/null)
if [ -z "$PLAYERS" ]; then
    # Tidak ada player - tampilkan default
    cp "$DEFAULT" "$COVER"
    rm -f "$LAST_INFO"
    exit 0
fi

# Cek apakah semua player stopped/paused tanpa lagu
ALL_STOPPED=true
for player in $PLAYERS; do
    STATUS=$(playerctl -p "$player" status 2>/dev/null)
    TITLE=$(playerctl -p "$player" metadata xesam:title 2>/dev/null)
    if [ -n "$TITLE" ]; then
        ALL_STOPPED=false
        break
    fi
done

if [ "$ALL_STOPPED" = true ]; then
    cp "$DEFAULT" "$COVER"
    rm -f "$LAST_INFO"
    exit 0
fi

for player in $PLAYERS; do
    ARTIST=$(playerctl -p "$player" metadata xesam:artist 2>/dev/null)
    TITLE=$(playerctl -p "$player" metadata xesam:title 2>/dev/null)

    [ -z "$ARTIST" ] && [ -z "$TITLE" ] && continue

    # Cek apakah lagu berubah
    CURRENT_INFO="${ARTIST}|${TITLE}"
    LAST=$(cat "$LAST_INFO" 2>/dev/null)
    if [ "$CURRENT_INFO" = "$LAST" ] && [ -f "$COVER" ] && [ -s "$COVER" ]; then
        exit 0
    fi

    # Coba artUrl dulu
    ART=$(playerctl -p "$player" metadata mpris:artUrl 2>/dev/null)
    if [ -n "$ART" ]; then
        if echo "$ART" | grep -q "^file://"; then
            ART_PATH=$(echo "$ART" | sed "s|file://||")
            if [ -f "$ART_PATH" ]; then
                cp "$ART_PATH" "$COVER"
                echo "$CURRENT_INFO" > "$LAST_INFO"
                exit 0
            fi
        else
            curl -s --max-time 5 "$ART" -o "$COVER" 2>/dev/null
            if [ -s "$COVER" ]; then
                echo "$CURRENT_INFO" > "$LAST_INFO"
                exit 0
            fi
        fi
    fi

    # Fallback YouTube thumbnail
    URL=$(playerctl -p "$player" metadata xesam:url 2>/dev/null)
    if echo "$URL" | grep -q "youtube.com\|youtu.be"; then
        VID=$(echo "$URL" | grep -oP '(?<=v=)[^&]+' | head -1)
        [ -z "$VID" ] && VID=$(echo "$URL" | grep -oP '(?<=youtu.be/)[^?]+' | head -1)
        if [ -n "$VID" ]; then
            curl -s --max-time 5 \
                "https://img.youtube.com/vi/${VID}/mqdefault.jpg" \
                -o "$COVER" 2>/dev/null
            if [ -s "$COVER" ]; then
                echo "$CURRENT_INFO" > "$LAST_INFO"
                exit 0
            fi
        fi
    fi

    # Fallback iTunes API
    if [ -n "$ARTIST" ] && [ -n "$TITLE" ]; then
        QUERY=$(python3 -c "import urllib.parse,sys; print(urllib.parse.quote(sys.argv[1]))" "${ARTIST} ${TITLE}" 2>/dev/null || \
                echo "${ARTIST} ${TITLE}" | sed 's/ /+/g')
        ART_URL=$(curl -s --max-time 10 \
            "https://itunes.apple.com/search?term=${QUERY}&media=music&limit=1" \
            2>/dev/null | grep -oP '"artworkUrl100":"\K[^"]+' | head -1)
        if [ -n "$ART_URL" ]; then
            ART_URL=$(echo "$ART_URL" | sed 's/100x100bb/300x300bb/')
            curl -s --max-time 10 "$ART_URL" -o "$COVER" 2>/dev/null
            if [ -s "$COVER" ]; then
                echo "$CURRENT_INFO" > "$LAST_INFO"
                exit 0
            fi
        fi
    fi
done

# Semua gagal - pakai default
cp "$DEFAULT" "$COVER"
