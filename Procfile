web: bin/bundle exec puma --port $PORT --threads ${PUMA_MIN_THREADS:-0}:${PUMA_MAX_THREADS:-5} --workers ${PUMA_WORKERS:-1} --quiet
worker: bin/bundle exec sidekiq --queue default --queue mailers --concurrency ${SIDEKIQ_CONCURRENCY:-5}
