#! /bin/bash
ssh -i ~/.ssh/private_key deploy@ipaddress tail -f /home/deploy/AppName/shared/log/production.log
