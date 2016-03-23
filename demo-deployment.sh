#!/bin/bash
set -xeuo pipefail

#### Demo prep script V1.0 - By Red Hat Global Enablement Team - Shachar Boresntein <sborenst@redhat.com>
#######################################################################################################################################################
#######################################################################################################################################################
################################################Common Tasks ##########################################################################################
#######################################################################################################################################################
#######################################################################################################################################################

# Vars
USER1="david"

#### Check that the nodes are configured correctly
nodes_online=0;
sleep_time=5 ;

node_ready() { # $1 = node
	oc get node $1 -o jsonpath --template '{.status.conditions[?(@.type == "Ready")].status}'
}

node_zone() { # $1 = node
	oc get node $1 -o jsonpath --template '{.metadata.labels.zone}'
}

node_region() { # $1 = node
	oc get node $1 -o jsonpath --template '{.metadata.labels.region}'
}

while [ $nodes_online == 0 ]; do

	echo "--- Checking all nodes are on-line, sleeping for ${sleep_time}s"
	sleep $sleep_time;

	nodes_online=1;

	# Checking that master is ready
	HOST=master;
	if [ "$(node_ready $HOST)" == "True" ]
	then
		echo "----$HOST is configured correctly and is ready"
	else
		echo "----$HOST is not ready"; nodes_online=0;
	fi

	# Checking that infranode is ready and in the infra region
	HOST=infranode;
	if [ "$(node_ready $HOST)" == "True" ] && \
	   [ "$(node_region $HOST)" == "infra" ] && \
	   [ "$(node_zone $HOST)" == "infranode" ]
	then
		echo "----$HOST is configured correctly and is ready"
	else
 		echo "----$HOST is not ready"; nodes_online=0;
	fi

	# Checking that Node00 is in the East Zone region
	HOST=node00;
	if [ "$(node_ready $HOST)" == "True" ] && \
	   [ "$(node_region $HOST)" == "primary" ] && \
	   [ "$(node_zone $HOST)" == "east" ]
	then
		echo "----$HOST is configured correctly and is ready"
	else
 		echo "----$HOST is not ready"; nodes_online=0;
	fi

	# Checking that Node01 is in the West Zone region
	HOST=node01;
	if [ "$(node_ready $HOST)" == "True" ] && \
	   [ "$(node_region $HOST)" == "primary" ] && \
	   [ "$(node_zone $HOST)" == "west" ]
	then
		echo "----$HOST is configured correctly and is ready"
	else
 		echo "----$HOST is not ready"; nodes_online=0;
	fi

done

oc get nodes

useradd ${USER1}

htpasswd -b /etc/origin/htpasswd ${USER1} 'r3dh4t1!'

oadm new-project hello-atomic-demo \
	--display-name="hello-atomic Demonstration"  \
	--description="hello-atomic Prebuilt container" \
	--node-selector='region=primary' \
	--admin=${USER1}

sleep 3;

oc get projects

cp /root/demo-resources/hello-atomic-pod.json /home/${USER1}
cp /root/demo-resources/hello-atomic-complete.json /home/${USER1}

### Fixing the GUID so that the .json file is set for our system.

GUID=$(ssh aeplab hostname)
GUID=${GUID%%.*} # trim .oslab.opentlc.com suffix
GUID=${GUID##*-} # trim aeplab- prefix

sed -i s/GUID/$GUID/g /home/${USER1}/hello-atomic-complete.json
