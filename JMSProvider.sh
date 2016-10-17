WAS_HOME=/opt/WebSphere/AppServer8.5.5/profiles/Dmgr01
SCRIPT_HOME=/home/wsadmin/JMSProvider
PROP_FILE=$SCRIPT_HOME/custom.properties

. $PROP_FILE
echo "$reconnectionRetryCount"

if [ ! -z "$reconnectionRetryCount" -a ! -z $startupRetryCount -a ! -z $reconnectionRetryInterval -a ! -z $startupRetryInterval ]
then
        #$WAS_HOME/bin/wsadmin.sh -lang jython $SCRIPT_HOME/ResourceAdoptor.py $reconnectionRetryCount $startupRetryCount $reconnectionRetryInterval $startupRetryInterval
        $WAS_HOME"/bin/wsadmin.sh" -lang jython -f $SCRIPT_HOME/ResourceAdoptor.py "$PROP_FILE"
        #$WAS_HOME"/bin/wsadmin.sh" -lang jython -f $SCRIPT_HOME/ResourceAdoptor.py
else
        echo " Please pass the values for all parameters in custom.properties file"
fi
