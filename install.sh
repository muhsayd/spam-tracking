if [ -e "/root/spam-tracking/" ]; then
	cd /root/spam-tracking/
	git pull https://github.com/muhsayd/spam-tracking.git >/dev/null
else
	cd /root
	git clone https://github.com/muhsayd/spam-tracking.git >/dev/null
fi
grep -q '/root/spam-tracking/track-spam.sh'  /var/spool/cron/root || echo "*	* * * * sh /root/spam-tracking/track-spam.sh >/dev/null 2>&1" >> /var/spool/cron/root
