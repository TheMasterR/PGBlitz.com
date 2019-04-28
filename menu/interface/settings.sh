#!/bin/bash
#
# Title:      PGBlitz (Reference Title File)
# Author(s):  Admin9705 - Deiteq
# URL:        https://pgblitz.com - http://github.pgblitz.com
# GNU:        General Public License v3.0
################################################################################
source /opt/plexguide/menu/functions/functions.sh
source /opt/plexguide/menu/functions/install.sh
# Menu Interface
setstart() {

emdisplay=$(cat /pg/var/emergency.display)
switchcheck=$(cat /pg/var/pgui.switch)
tee <<-EOF

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🚀 PG Settings Interface Menu
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[1] Download Path    :  Change the Processing Location
[2] MultiHD          :  Add Multiple HDs and/or Mount Points to MergerFS
[3] Processor        :  Enhance the CPU Processing Power
[4] WatchTower       :  Auto-Update Application Manager
[5] Change Time      :  Change the Server Time
[6] PG UI            :  $switchcheck | Port 8555 | pgui.domain.com
[7] Emergency Display:  $emdisplay
[Z] Exit

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF

# Standby
read -p 'Type a Number | Press [ENTER]: ' typed < /dev/tty

case $typed in
    1 )
      bash /opt/plexguide/menu/dlpath/dlpath.sh
      setstart ;;
    2 )
      bash /opt/plexguide/menu/pgcloner/multihd.sh ;;
    3 )
      bash /opt/plexguide/menu/processor/processor.sh
      setstart ;;
    4 )
      watchtower ;;
    5 )
      dpkg-reconfigure tzdata ;;
    6 )
      echo
      echo "Standby ..."
      echo
      if [[ "$switchcheck" == "On" ]]; then
         echo "Off" > /pg/var/pgui.switch
         docker stop pgui
         docker rm pgui
      else echo "On" > /pg/var/pgui.switch
        bash /opt/plexguide/menu/pgcloner/solo/pgui.sh
        ansible-playbook /opt/pgui/pgui.yml
      fi
      setstart ;;
    7)
       if [[ "$emdisplay" == "On" ]]; then echo "Off" > /pg/var/emergency.display
       else echo "On" > /pg/var/emergency.display; fi
       setstart ;;
    z )
      exit ;;
    Z )
      exit ;;
    * )
      setstart ;;
esac

}

setstart
