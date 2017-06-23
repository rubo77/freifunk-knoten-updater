#!/bin/bash


function go(){
  ### router updaten
  count=0
  while [ "x${router[count]}" != "x" ]
  do
    count=$(( $count + 1 ))
    echo
    date
    echo "# "${router[$count]}
    echo password: ${p[$count]}
    
    ROUTER_IP=${router_ip[$count]}
    LOGIN="root@[$ROUTER_IP]"
    
    #enable roamguide:
    #ssh root@${router_ip[$count]} 'uci set roamguide.@roamguide[0].enabled="1"; uci commit roamguide; grep -q /usr/bin/roamguide /etc/crontabs/root || (echo "* * * * * /usr/bin/roamguide" >> /etc/crontabs/root; echo "* * * * * sleep 20 & /usr/bin/roamguide" >> /etc/crontabs/root; echo "* * * * * sleep 40 & /usr/bin/roamguide" >> /etc/crontabs/root)'
    #ssh ${router_ip[$count]} 'uci show roamguide.@roamguide[0].enabled; cat /etc/crontabs/root'


    #logread |grep -v "fastd" & logread -f |grep -v "fastd"

    # update all nodes
    # adapt your version and folder here:
    FW=2016.2.6
    cd /var/www/freifunk/firmware/ffki/$FW/stable/
    MODEL=$(ssh root@$ROUTER_IP "lua -e 'print(require(\"platform_info\").get_image_name())'")
    FILENAME=gluon-ffki-$FW-$MODEL-sysupgrade.bin
    if [ -f $FILENAME ];then
      echo copying $FILENAME
      scp $FILENAME $LOGIN:/tmp;
      echo start upgrade
      ssh $ROUTER_IP sysupgrade /tmp/$FILENAME
    else
      echo $FILENAME not found
      exit
    fi

    # add ssid-changer:
    #
    #cd /var/www/freifunk/gluon-ssid-changer/gluon-ssid-changer
    #scp -r files/* $LOGIN:/
    #scp luasrc/lib/gluon/upgrade/500-ssid-changer $LOGIN:/lib/gluon/upgrade/
    #ssh $ROUTER_IP "/lib/gluon/upgrade/500-ssid-changer;" \
    #"uci set ssid-changer.settings.first='1';" \
    #  "uci set ssid-changer.settings.switch_timeframe='1';" \
    #  "uci commit ssid-changer;" \
    #  "uci show ssid-changer;" \
    #  "/etc/init.d/micrond reload;" 

    #   ssh -tt ruben@freifunk.in-kiel.de ssh -tt root@${router_ip[$count]} <<SSH
    #      echo wget http://[fda1:384a:74de:4242::cc00]/firmware/release-candidate/sysupgrade/gluon-ffki-2016.2.4~rc1703171040-$(lua -e  #'print(require("platform_info").get_image_name())')-sysupgrade.bin
    #SSH
    #exit
    #ssh -tt ruben@freifunk.in-kiel.de ssh -tt root@${router_ip[$count]} 'V=$(/usr/bin/lua -e "print(require(\"platform_info\").get_image_name())");echo "$V";'
    #wget https://freifunk.in-kiel.de/firmware/release-candidate/sysupgrade/gluon-ffki-2016.2.4~rc1703171040-\"\$V\"-sysupgrade.bin"
    #exit

    #  echo "Router updaten per direct link"
    #  LUA="lua -e 'print(require(\"platform_info\").get_image_name())'"
    #  echo "V=\$($LUA)"
    #  echo cd /tmp/\;
    #  echo wget http://[fda1:384a:74de:4242::fd00]/firmware/release-candidate/sysupgrade/gluon-ffki-2016.2.4~rc1703171040-\$V-sysupgrade.bin
    #  echo ssh -tt ruben@freifunk.in-kiel.de ssh -tt root@${router_ip[$count]} 
    #'V="$("$LUA")"; echo "$V"'
    #
    #
    #echo "set good_signatures temporarily to 1 and start autoupdater";
    #ssh root@${router_ip[$count]} "echo -n 'vorher: '; uci show autoupdater|grep good_sig; uci set autoupdater.stable.good_signatures='1'; uci show autoupdater|grep hostname; date; autoupdater -f"
    #
    #
    # set autoupdater branch auf stable
    #ssh root@${router_ip[$count]} "echo -n 'vorher: '; uci get autoupdater.settings.branch; uci set autoupdater.settings.branch='stable'; uci commit autoupdater; "
    #exit
  done
}

# first entry to start array:
router+=("x")
p+=("y")
router_ip+=("x")

###############


router+=("first routername")
p+=("your password")
router_ip+=("fdxx::xx:xx")

router+=("second routername")
p+=("your password")
router_ip+=("fdxx::xx:xx")
