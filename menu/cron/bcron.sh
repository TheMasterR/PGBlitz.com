#!/bin/bash
#
# Title:      PGBlitz (Reference Title File)
# Author(s):  Admin9705 - Deiteq
# URL:        https://pgblitz.com - http://github.pgblitz.com
# GNU:        General Public License v3.0
################################################################################
pgrole=$(cat /tmp/program_var)
path=$(cat /pg/var/server.hd.path)
tarlocation=$(cat /pg/var/data.location)
serverid=$(cat /pg/var/pg.serverid)

doc=no
rolecheck=$(docker ps | grep -c "\<$pgrole\>")
if [ $rolecheck != 0 ]; then docker stop $pgrole && doc=yes; fi

tar \
--ignore-failed-read \
--warning=no-file-changed \
--warning=no-file-removed \
-cvzf $tarlocation/$pgrole.tar /opt/appdata/$pgrole/

if [ $doc == yes ]; then docker restart $pgrole; fi

chown -R 1000:1000 $tarlocation
rclone --config /opt/appdata/plexguide/rclone.conf copy $tarlocation/$pgrole.tar gdrive:/plexguide/backup/$serverid -v --checksum --drive-chunk-size=64M

du -sh --apparent-size /opt/appdata/$pgrole | awk '{print $1}'
rm -rf '$tarlocation/$pgrole.tar'
