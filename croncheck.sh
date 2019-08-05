#!bin/bash

# 出力ファイル名
DEST=croncheck.md

touch $DEST
echo -e "# croncheck\n" > $DEST

echo "## os" >> $DEST
echo  "\`\`\`" >>$DEST
cat /etc/redhat-release >>$DEST 2>&1
echo -e "\`\`\`\n" >>$DEST

echo "## crontab -l" >> $DEST
echo  "\`\`\`" >>$DEST
crontab -l >>$DEST 2>&1
echo -e "\`\`\`\n" >>$DEST

# ユーザー個別のcron設定を出力する
echo "## user crontab" >> $DEST
echo  "\`\`\`" >>$DEST
cut -d: -f1 /etc/passwd >>$DEST 2>&1
echo -e "\`\`\`\n" >>$DEST

if which crontab > /dev/null 2>&1; then
	users=`cut -d: -f1 /etc/passwd | grep -v "#"`
	for user in ${users}; do
		if [[ !(${user} == *"#"*) ]]; then 
			echo "### crontab -u ${user} -l" >>$DEST
			echo -e "\`\`\`" >>$DEST
			crontab -u ${user} -l >>$DEST 2>&1
			echo -e "\`\`\`\n" >>$DEST
		fi
	done
fi

echo -e "## cat /etc/crontab" >> $DEST
echo -e "\`\`\`" >>$DEST
cat /etc/crontab >>$DEST 2>&1
echo -e "\`\`\`\n" >>$DEST

echo -e "## ls -1R /etc/cron.d" >> $DEST
echo -e "\`\`\`" >>$DEST
ls -1R /etc/cron.d >>$DEST 2>&1
echo -e "\`\`\`\n" >>$DEST

for file in /etc/cron.d/*; do
	echo "### ${file}" >>$DEST
	echo -e "\`\`\`" >>$DEST
	cat ${file} >>$DEST 2>&1
	echo -e "\`\`\`\n" >>$DEST
done

echo -e "---\n" >>$DEST
