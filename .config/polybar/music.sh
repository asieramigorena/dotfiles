#!/bin/bash

# Verifica si hay música sonando
status=$(playerctl status 2>/dev/null)

if [ "$status" = "Playing" ]; then
    # Obtener artista y título
    artist=$(playerctl metadata artist 2>/dev/null)
    title=$(playerctl metadata title 2>/dev/null)
    
    # Longitud máxima total (artista + " - " + título)
    maxlen=40
    full="${artist} - ${title}"

    # Truncado si es demasiado largo
    if [ ${#full} -gt $maxlen ]; then
        # Truncar el título primero
        available=$((maxlen - ${#artist} - 3))  # 3 para " - "
        if [ $available -lt 1 ]; then
            available=1
        fi
        title="${title:0:available}…"
        full="${artist} - ${title}"
    fi

    # Mostrar artista en color #F0C674, título normal
    echo "%{F#F0C674}${artist}%{F-} - ${title}"
fi
