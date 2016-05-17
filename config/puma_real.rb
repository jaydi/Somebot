#!/usr/bin/env puma

tag 'somebot-server'

pidfile 'tmp/pids/puma.pid'
state_path 'tmp/pids/puma.state'
stdout_redirect 'log/access_log', 'log/error_log', true

threads 1, 16
workers 1
daemonize true

bind 'unix:///tmp/puma.sock'

# preload_app!
prune_bundler