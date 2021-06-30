#! /bin/bash
ssh -i ~/.ssh/<%= @private_ssh_key %> deploy@<%= @server_ip %> tail -f /home/deploy/<%= @app_name %>/shared/log/production.log
