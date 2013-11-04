web: bin/bundle exec puma --port $PORT --threads ${PUMA_MIN_THREADS:-0}:${PUMA_MAX_THREADS:-5} --workers ${PUMA_WORKERS:-1} --quiet
worker: bundle exec sidekiq -e $RACK_ENV -c ${SIDEKIQ_CONCURRENCY:-7}
mailman: bin/mailman

