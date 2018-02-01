#!/bin/bash

set -e

#############
# show all instance related to TAG
function list_instance () {
  #############################
  ## Get list of runnin instances with Nginx Tag
  # all in loop && verify port 22tcp and 80tcp
  AWS_LIST=$(awless list instances --tag TAG=Ngins --filter state=running | awk '{print $2}'| tail -n +3)
  for instance_id in $AWS_LIST ; do
    AWS_IP=$(awless show $instance_id | grep PublicDNS | awk '{print $4}')
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
  #### function will get list of Stoped instances
  ### create image each of then and Assign tags DATA EPOC - tags
  ## and Name by pattern ($AWS_NAMES_STOPED$(date +%Y-%m-%d_%H-%M-%S))
  # last step will terminate instance
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
    yes | awless delete instance ids=$instance_id
  done
  #statements
}
function imges_rotation {
  #### function image rotation dealing only with images
  ### && BY DESIGN && the way comparing day of creation and current date EPOC time
  ## it will get EPOC time creation image from TAG 'EPOC' and comrate it with current time
  # 7 days in seconds will be 604800
  ALL_IMAGES_IDS=$(awless list images | grep ami |   awk '{print $2}')
  for image_id in $ALL_IMAGES_IDS ; do
    create_time=""
    while [ "$create_time" == "" ] ; do
      create_time=$(awless show $image_id | awk '{print $4}' | grep EPOC | cut -d '=' -f 2)
      echo "$create_time"
    done
    curent_epoc_time=$(date +%s)
    diff=$(expr $curent_epoc_time - $create_time )
    echo "$diff - diff time in EPOC"
    seven_EPOC="604800"
    if [ $diff -gt $seven_EPOC ] ; then
      yes | awless delete image id=$image_id
      echo "Image $image_id was secsesful removed from AWS"
    else
      echo "Image $image_id not exired yet "
    fi
    create_time=""
  done
  #statements
}

function current_cloud_state {
  awless list instances
  awless list images
  #statements
}

list_instance
create_image
imges_rotation
current_cloud_state

exit 0
