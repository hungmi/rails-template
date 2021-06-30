#! /bin/bash
ssh -i ~/.ssh/<%= @private_ssh_key %> deploy@<%= @server_ip %>
