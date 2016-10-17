import sys
import os.path
import sys,java
from java.util import Properties
from java.io import FileInputStream
#home = sys.argv[0].strip( )

propfile = sys.argv[0].strip( )
lineSep = java.lang.System.getProperty('line.separator')
properties=Properties();
try:
    properties.load(FileInputStream(propfile))
    print "Succesfully read property file "+propfile

except:
    print "Cannot read property file "+propfile
    sys.exit(-1)

reconnectRetryCount = str(properties.getProperty("reconnectionRetryCount")).strip( )
RetryCount = str(properties.getProperty("startupRetryCount")).strip( )
reconnectionRetryInterval = str(properties.getProperty("reconnectionRetryInterval"))
startupRetryInterval = str(properties.getProperty("startupRetryInterval"))

Resources=AdminUtilities.convertToList(AdminConfig.list('J2CResourceAdapter'))
cnt = 0
for Resource in Resources:
 wmq=Resource.split("(")[0].split("\"")
 #print wmq[1]
 if wmq[1]:
        if wmq[1]== "WebSphere MQ Resource Adapter":
                try:
                 resources= AdminTask.showWMQ(Resources[cnt]).split(",")
                 #print resources
                 for r1 in resources :
                  #print r1
                  recoon = r1.split("=")
                  custom = "[[ startupRetryCount " +RetryCount+" ]]"
                  custom1 = "[[ startupRetryInterval " +startupRetryInterval+" ]]"
                  #print custom
                  parameters = "-reconnectionRetryCount " +reconnectRetryCount+ " -customProperties "+custom+" "
                  parameters1 = "-reconnectionRetryInterval " +reconnectionRetryInterval+ " -customProperties "+custom1+" "
                  #print parameters
                  AdminTask.manageWMQ(Resources[cnt],[ parameters ])
                  AdminConfig.save()
                  AdminTask.manageWMQ(Resources[cnt],[ parameters1 ])
                  AdminConfig.save()
                except :
                 print "failed"
 cnt = cnt +1

