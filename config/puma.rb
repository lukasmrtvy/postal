require_relative '../lib/postal/config'
threads_count = Postal.config.web_server&.max_threads&.to_i || 5
threads         threads_count, threads_count
bind_address  = Postal.config.web_server&.bind_address || '127.0.0.1'
bind_port     = Postal.config.web_server&.port&.to_i || 5000
environment     Postal.config.rails&.environment || 'development'
prune_bundler
quiet false

if ssl_enabled
	bind  "ssl://#{bind_address}:#{bind_port}?key=#{server_key}&cert=#{server_crt}&ssl_cipher_list=#{ssl_ciphers}"
else
	bind  "tcp://#{bind_address}:#{bind_port}"

unless ENV['LOG_TO_STDOUT']
  stdout_redirect Postal.log_root.join('puma.log'), Postal.log_root.join('puma.log'), true
end

if ENV['APP_ROOT']
  directory ENV['APP_ROOT']
end
