for msgid in `exiqgrep -i`; 
do
	if ! $( grep -q $msgid spame-summary.txt );
	then
		subject=`exim -Mvh $msgid | egrep 'Subject:' | cut -d: -f2-`; 
		ip=`exim -Mvh $msgid | egrep 'Received: from' | awk -F'[' '{print $2}' | awk -F']' '{print $1}'`; 
		helo=`exim -Mvh $msgid | egrep 'Received: from' | awk -F'helo=' '{print $2}' | awk -F')' '{print $1}'`; 
		reciept=`exim -Mvh $msgid | egrep ' To: ' | awk -F' To: ' '{print $2}'`; 
		sender=`exim -Mvh $msgid | egrep ' From: ' | awk -F' From: ' '{print $2}' | awk -F'<' '{print $2}' | awk -F'>' '{print $1}'`; 
		script=`exim -Mvh $msgid | egrep ' X-PHP-Script: ' | awk -F' X-PHP-Script: ' '{print $2}' | awk -F ' for ' '{print $1}'`;
		echo "MSGID:$msgid; Sender:$sender; ReCeipt:$reciept; Script:$script; IP:$ip; Helo:$helo; Subject:$subject" >> spame-summary.txt
	fi
	done
