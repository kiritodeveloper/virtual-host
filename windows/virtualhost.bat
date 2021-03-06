@echo off

set httpd_conf_file='C:\xampp\apache\httpd.conf';
set hosts_file='C:\windows\system32\Drivers\etc\host';
set server_name='';

check:
    if [ "$httpd_conf_file" = "" ]; then
        echo "You must config the httpd_conf_file!";
        exit 1
    fi
    
    if ! [ -f $httpd_conf_file ]; then
        echo "The $httpd_conf_file does not exist, please check your config";
        exit 1
    fi

    if ! [ -f $hosts_file ]; then
        echo "The $hosts_file does not exist, please check your config";
        exit 1
    fi

    echo '' >> $httpd_conf_file;
    
    if [ $? = 1 ]; then
        echo "You don't have pemission to write $httpd_conf_file, please use sudo";
        exit
    fi
    
    echo '#Auto add virtual host' >> $httpd_conf_file;
    

add_virtual_host:
    echo "Please enter your DocumentRoot ('/Library/WebServer/Documents/YourSite') :";
    read document_root;
    echo "Please enter your ServerName ('www.yoursite.com') :";
    read server_name;
    virtual_host="
    <VirtualHost *:80>\n
        DocumentRoot '$document_root'\n
        ServerName $server_name\n
    </VirtualHost>\n
    "
    echo -e $virtual_host >> $httpd_conf_file;

    directory_options="
    <Directory '$document_root'>\n
        Options Indexes FollowSymLinks MultiViews\n
        AllowOverride All\n
        Order allow,deny\n
        Allow from all\n
    </Directory>
    "
    echo -e $directory_options >> $httpd_conf_file;
    echo '#Auto add virtual host end' >> $httpd_conf_file;
    

add_host:
   host="127.0.0.1  $server_name";
   echo '' >> $hosts_file;
   echo '#Auto add virtual host' >> $hosts_file;
   echo $host >> $hosts_file;
   echo '#Auto add virtual host end' >> $hosts_file;

goto check
goto add_virtual_host
goto add_host
echo "Successfully add virtual host, please :\n
1. restart your apache service (xampp control panel [restart apache])\n
2. go to $server_name check ($ open http://$server_name)\n"
pause
exit