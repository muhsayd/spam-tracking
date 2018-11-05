OFLIFS=$IFS
IFS='
'
for line in `grep 'actual sender does not match' /var/log/exim_mainlog | cut -d '[' -f2- | sort -u`; 
do 
	aemail=`echo ${line} | awk -F'actual_sender' '{print $2}' | awk -F '[' '{print $2}' | awk -F ']' '{print $1}'`; 
	femail=`echo ${line} | awk -F ']' '{print $1}'`;
	if ! $(grep -q ${aemail} emails-passwords.txt);
	then 
		pass="`mkpasswd -l 12`"
		result=`/usr/local/cpanel/3rdparty/bin/perl /root/modpop ${aemail} ${pass}` 
		echo "Fake Email: ${femail} <==> Actual Email: ${aemail}" | tee -a emails-passwords.txt; 
		echo "$result" | tee -a emails-passwords.txt
		if $( exiqgrep -i -f "${femail}" | grep -q "${femail}" );
		then
			exiqgrep -i -f "${femail}" | xargs exim -Mrm
		fi
		if $( exiqgrep -i -f "${aemail}" | grep -q "${aemail}" );
                then
                        exiqgrep -i -f "${aemail}" | xargs exim -Mrm
                fi

	fi
done
IFS=$OFLIFS
