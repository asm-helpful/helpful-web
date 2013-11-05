web: bin/puma --port $PORT --threads ${PUMA_MIN_THREADS:-0}:${PUMA_MAX_THREADS:-5} --workers ${PUMA_WORKERS:-1}
worker: bin/sidekiq --concurrency ${SIDEKIQ_CONCURRENCY:-5}
mailman: bin/mailman
