#!/bin/sh

for file in /iptv-api-config/*; do
  filename=$(basename "$file")
  target_file="$APP_WORKDIR/config/$filename"
  if [ ! -e "$target_file" ]; then
    cp -r "$file" "$target_file"
  fi
done

. /.venv/bin/activate

(crontab -l ; \
if [ -n "$UPDATE_CRON1" ]; then echo "$UPDATE_CRON1 cd $APP_WORKDIR && /.venv/bin/python main.py"; fi; \
if [ -n "$UPDATE_CRON2" ]; then echo "$UPDATE_CRON2 cd $APP_WORKDIR && /.venv/bin/python main.py"; fi) | crontab -

service cron start &

python $APP_WORKDIR/main.py &

python -m gunicorn service.app:app -b 0.0.0.0:$APP_PORT --timeout=1000