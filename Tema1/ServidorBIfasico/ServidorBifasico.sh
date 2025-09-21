is_open() {
  nc -z -w1 "$1" "$2" >/dev/null 2>&1 && echo "open" || echo "closed"
  # nc: netcat
  # -z: modo escaneo, no envía datos
  # -w1: timeout 1 segundo
  # $1: IP
  # $2: puerto
  # >/dev/null 2>&1: descarta salida
  # && echo "open": si conecta, imprime "open"
  # || echo "closed": si falla, imprime "closed"
}

# Comprobar puertos 22 y 8080
echo -n "Puerto 22: "; p22=$(is_open "$TARGET_IP" 22); echo "$p22"
echo -n "Puerto 8080: "; p8080=$(is_open "$TARGET_IP" 8080); echo "$p8080"

# Si ambos puertos cerrados, preguntar si hacer golpeo
if [ "$p22" = "closed" ] && [ "$p8080" = "closed" ]; then
  read -rp "Ambos cerrados. ¿Golpeo? (s/n): " R
  case "$R" in
    [sS]*)  # Coincide con cualquier entrada que empiece por s o S
      read -rp "Tu usuario: " USER   # Pedir nombre de usuario
      TS=$(date +%Y%m%d-%H%M)       # Fecha y hora en formato YYYYMMDD-HHmm
      echo "$TS $USER $TARGET_IP knock" >>"$LOGFILE"  # Guardar log
      echo "Log guardado en $LOGFILE"

      # Si existe el comando 'knock', usarlo
      if command -v knock >/dev/null 2>&1; then
        knock "$TARGET_IP" "${KNOCK_SEQUENCE[@]}"
        # "${KNOCK_SEQUENCE[@]}": expande array como lista de argumentos separados
      else
        # Fallback: usar nc para enviar conexiones rápidas a cada puerto
        for p in "${KNOCK_SEQUENCE[@]}"; do
          nc -w1 "$TARGET_IP" "$p" >/dev/null 2>&1 || true
          # nc -w1: conexión rápida
          # || true: evita que falle el script si no conecta
          sleep 0.2   # esperar 0.2s entre golpes
        done
      fi

      echo "Golpe enviado. Intenta SSH ahora."
      ;;
    *)  # Cualquier otra respuesta
      echo "Cancelado."
      ;;
  esac
else
  echo "Al menos un puerto está abierto; Abortando port knocking..."
fi