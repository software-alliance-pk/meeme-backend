threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
threads threads_count, threads_count
port ENV.fetch("PORT") { 3000 }
worker_timeout 3600 if ENV.fetch("RAILS_ENV", "development") == "development"
 if ENV.fetch("RAILS_ENV", "production") == "production"
   bind "unix:///var/www/memee-app/tmp/sockets/puma.sock";
 end
environment ENV.fetch("RAILS_ENV") { "production" } if ENV.fetch("RAILS_ENV", "production") == "production"
environment ENV.fetch("RAILS_ENV") { "development" }  if ENV.fetch("RAILS_ENV", "development") == "development"
pidfile ENV.fetch("PIDFILE") { "tmp/pids/server.pid" }

plugin :tmp_restart