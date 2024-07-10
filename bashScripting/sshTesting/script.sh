connectTo="admin@192.168.1.216"
passwd=`cat private_passwd`
sshpass -f <(printf '%s\n' $passwd) ssh $connectTo "bash -s" << EOF
    touch /home/admin/test
EOF
