## mongo Centos 7 install

```bash

# run as root

echo "[mongodb-org-4.4]

name=MongoDB Repository

baseurl=https://repo.mongodb.org/yum/redhat/\\$releasever/mongodb-org/4.4/x86_64/

gpgcheck=1

enabled=1

gpgkey=https://www.mongodb.org/static/pgp/server-4.4.asc" > /etc/yum.repos.d/mongodb-org-4.4.repo

yum install -y mongodb-org checkpolicy policycoreutils-python

ulimit -n 64000

cat > mongodb_cgroup_memory.te <<EOF

module mongodb_cgroup_memory 1.0;

require {

type cgroup_t;

type mongod_t;

class dir search;

class file { getattr open read };

}

#============= mongod_t ==============

allow mongod_t cgroup_t:dir search;

allow mongod_t cgroup_t:file { getattr open read };

EOF

checkmodule -M -m -o mongodb_cgroup_memory.mod mongodb_cgroup_memory.te

semodule_package -o mongodb_cgroup_memory.pp -m mongodb_cgroup_memory.mod

sudo semodule -i mongodb_cgroup_memory.pp

cat > mongodb_proc_net.te <<EOF

module mongodb_proc_net 1.0;

require {

type proc_net_t;

type mongod_t;

class file { open read };

}

#============= mongod_t ==============

allow mongod_t proc_net_t:file { open read };

EOF

systemctl start mongod

systemctl enable mongod

firewall-cmd --zone=public --permanent --add-service=mongodb

firewall-cmd --reload

# add users

mongo

use admin

db.createUser(

{

user: "mcwertgaming",

pwd: passwordPrompt(),

roles: [ { role: "root", db: "admin" } ]

}

)

use serviceUser

db.createUser(

{

user: "rocketchatUser",

pwd: passwordPrompt(),

roles: [ { role: "readWrite", db: "rocketchat" },

{ role: "readWrite", db: "local" }]

}

)

# show users

show users

db.shutdownServer()

exit

# change bind ip in /etc/mongo.conf

echo -e "security:\\n authotization: \\"enabled\\" \\nreplication:\\n oplogSizeMB: 1024\\n replSetName: \\"rs01\\"\\n" | sudo tee -a /etc/mongod.conf

```