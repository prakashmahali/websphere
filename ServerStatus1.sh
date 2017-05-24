#!/bin/sh
REPORTFILE=validation.txt
touch $REPORTFILE
cat $REPORTFILE >/dev/null
PROPERTIESFILE=validation.properties
touch $PROPERTIESFILE
cat $PROPERTIESFILE >/dev/null

ID=`id -u -n`
#echo $ID
user=`grep $ID /etc/passwd | wc -l`
#echo $user
if [ $user > 0 ]
then
        echo "User $ID Found"
else
        echo "user $ID not found "
fi
Group=`id -Gn $ID `
#echo $Group
Groupfound=`grep $Group /etc/group | wc -l `
#echo $Groupfound
if [ $Groupfound > 0 ]
then
        echo "Group  $Group Found"
else
        echo "Group $Group not found "
fi
#verify xdeploy id exists and is part of websuppt
#i am using wsadmin and wsgroup
id=wsadmin
idfound=`grep $id /etc/passwd | wc -l `

if [ $idfound > 0 ]
then
        echo "$id exists "
else
        echo "$id not exists"
fi
group=`id -Gn $id`
if [ $group == "wsgroup" ]
then
        echo "$id present under $group "
else
        echo "$id notpresent under $group "
fi

#7 -i --)        Verify that there is %80 or less for the /root directory

diskspace=`df -hT / | awk '0+$5 >= 80 {print}' | wc -l`
if [ $diskspace == 1 ]
then
        echo "Disk space of root file system is more than 80%"
        echo `df -hT / | awk '0+$5  {print}'`
else
        echo "Disk space of root file system is less than 80%"
        echo `df -hT / | awk '0+$5 {print}'`
fi
#8)      Verify Memory
#i)There should be the requested amount of memory in GB plus 2 GB swap memory
	echo "Total  " `free -g  | grep ^Mem | tr -s ' ' | cut -d ' ' -f 1-2 ` " GB "
	echo "Total  "`free -g  | grep ^Swap | tr -s ' ' | cut -d ' ' -f 1-2 ` " GB "
#ii)       Verify there is enough free for your needs as well.
	echo "Free   " `free -g  | grep ^Mem | tr -s ' ' | cut -d ' ' -f 1,4 ` " GB "
	echo "Free  "`free -g  | grep ^Swap | tr -s ' ' | cut -d ' ' -f 1,4 ` " GB "






#9)      Validate Open File Limits, etc.
#a
if [ $ID == "wsadmin" ]
then
	echo `ulimit -a `| tee $REPORTFILE
	echo "max user processes : "`ulimit -u ` | tee $PROPERTIESFILE
	echo "open files  : " `ulimit -n` | tee $PROPERTIESFILE
else
	echo " you should login as webproc "
fi
	
