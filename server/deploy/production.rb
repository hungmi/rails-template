# deploy/production.rb
server "<%= @server_ip %>", user: 'deploy', roles: %w{app db web}
set :ssh_options, {
	keys: %w(~/.ssh/<%= @private_ssh_key %>),
	forward_agent: false,
	auth_methods: %w(publickey)
}
set :branch, proc { `git rev-parse --abbrev-ref main`.chomp }
set :rails_env, "production"