#!/bin/bash

set -e

#############
# show all instance related to TAG
function list_instance () {
  #############################
  ## Get list of runnin instances with Nginx Tag
  # it will be list so we do loop
  AWS_LIST=$(awless list instances --tag TAG=Ngins --filter state=running | awk '{print $2}'| tail -n +3)
  for instance_id in $AWS_LIST ; do
    AWS_IP=$(awless show $instance_id | grep PublicDNS | awk '{print $4}')
    #### check 22tcp and 80tcp
    ## if error exit 1
    nc -w 2 -v $AWS_IP 22 </dev/null; echo $?  || exit 1
    ############################### verify exit code
    nc -w 2 -v $AWS_IP 80 </dev/null; echo $?  || exit 1
    ############################### verify exit code
    echo "with on host $AWS_IP running SSH and HTTP services "
  done
  #statements
}
function create_image {
  #############################
  ### function create image Only stoped instances
  ## as well it's can be list to _ so we do loop
  AWS_ID_STOPED=$(awless list instances --tag TAG=Ngins | grep stopped | awk '{print $2}')
  for instance_id in $AWS_ID_STOPED ; do
    ### Get stopped instances name and cteate image Assign property Name=$Name_and_data
    ## loop for each element from list
    AWS_NAMES_STOPED=$(awless list instances --filter state=stopped,type=t2.micro,id=$instance_id | awk '{print $6}'| tail -n +3)
      SUM=$AWS_NAMES_STOPED$(date +%Y-%m-%d_%H-%M-%S)
    yes | awless create image instance=$instance_id name=$SUM > raw.txt 2>&1
    IMAGE_ID=$(cat raw.txt | grep "create image ("| cut -d '(' -f 2 | cut -d ')' -f 1 )
    DATE=$(date +%Y:%m:%d)
    EPOC=$(date +%s)
    #IMAGE_ID=$(awless list images  --filter name="$AWS_NAMES_STOPED" | awk '{print $2}'| tail -n +3)
    yes | awless create tag key=DATE resource=$IMAGE_ID value=$DATE
    yes | awless create tag key=EPOC resource=$IMAGE_ID value=$EPOC
  done
  #statements
}
list_instance
create_image


exit 0
