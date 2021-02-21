# connectome_server_passwd_all

This repository is for administrators (conmasters) of the Connetome LAB server.   
This code shows the result of synthesizing the real-time account registration status (/etc/passwd) of each server (gateway, master, node1, node2, storage).   
And, only account information belonging to Connectome Lab with UID from 10000 to 19999 or  is displayed.   
Currently (2020/2/22), the administrator's RSA key is not registered, so the administrator must enter the password every time.   
If you register the RAS key later, you can see the result with just a shell command.



### Run

~~~Bash
conmaster@gateway:~/server_management$ ./server_user_status.sh 
~~~


### Result
~~~Bash
    #	gateway     master      node1       node2       storage     Account     
    1	O           O           O           O           O           conmaster:x:10000:10000:,,,:/home/connectome/conmaster:/bin/bash
    2	O           O           O           O           O           dong:x:10008:10000:,,,:/home/connectome/dong:/bin/bash
    3	O           O           O           O           O           joo:x:10001:10000:,,,:/home/connectome/joo:/bin/bash
    4	O           O           O           O           O           junb:x:10005:10000:,,,:/home/connectome/junb:/bin/bash
    5	O           X           X           X           X           rehappydoc:x:1001:10000:,,,:/home/rehappydoc:/bin/bash
~~~
