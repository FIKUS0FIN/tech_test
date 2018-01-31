#!/bin/bash

set -e

#############
# show all instance related to TAG
function list_instance () {
  AWS_LIST=$(awless list instances --tag TAG=Ngins | grep running  | awk '{print $2}')
  for instance_id in $AWS_LIST ; do
    AWS_IP=$(awless show $instance_id | grep PublicDNS | awk '{print $4}')
    #### check 22tcp and 80tcp
     nc -w 2 -v $AWS_IP 22 </dev/null; echo $?  || exit 1
     nc -w 2 -v $AWS_IP 80 </dev/null; echo $?  || exit 1
     echo "with on host $AWS_IP running SSH and HTTP services "
  done
  #statements
}
function create_image {
  AWS_ID_STOPED=$(awless list instances --tag TAG=Ngins | grep stopped | awk '{print $2}')
  for instance_id in $AWS_ID_STOPED ; do
    AWS_NAMES_STOPED=$(awless list instances --filter state=stopped,type=t2.micro,id=$AWS_ID_STOPED | awk '{print $6}'| tail -n +3)
    SUM=$AWS_NAMES_STOPED$(date +%Y-%m-%d)
    awless create image instance=$AWS_ID_STOPED name=$SUM
  #  IMAGE_ID=$(awless list images  --filter name="$AWS_NAMES_STOPED" | awk '{print $2}'| tail -n +3)
  #  awless create tag key=DATE resource=$IMAGE_ID value=$DATE
  done
  #statements
}

list_instance
create_image
