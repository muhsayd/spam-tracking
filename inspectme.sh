for msgid in `/usr/sbin/exiqgrep -i`; 
do
	if ! $( grep -q $msgid /root/spam-summary.txt );
	then
		subject=`/usr/sbin/exim -Mvh $msgid | egrep 'Subject:' | cut -d: -f2-`; 
		ip=`/usr/sbin/exim -Mvh $msgid | egrep 'Received: from' | awk -F'[' '{print $2}' | awk -F']' '{print $1}'`; 
		helo=`/usr/sbin/exim -Mvh $msgid | egrep 'Received: from' | awk -F'helo=' '{print $2}' | awk -F')' '{print $1}'`; 
		reciept=`/usr/sbin/exim -Mvh $msgid | egrep ' To: ' | awk -F' To: ' '{print $2}'`; 
		sender=`/usr/sbin/exim -Mvh $msgid | egrep ' From: ' | awk -F' From: ' '{print $2}' | awk -F'<' '{print $2}' | awk -F'>' '{print $1}'`; 
		script=`/usr/sbin/exim -Mvh $msgid | egrep ' X-PHP-Script: ' | awk -F' X-PHP-Script: ' '{print $2}' | awk -F ' for ' '{print $1}'`;
		echo "MSGID:$msgid; Sender:$sender; ReCeipt:$reciept; Script:$script; IP:$ip; Helo:$helo; Subject:$subject" >> /root/spam-summary.txt
	fi
	done
