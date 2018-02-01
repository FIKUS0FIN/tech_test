# tech_test

Tech task

- [x] Edit Nameservers form my domaine register ( take names from new host zone )
￼

- [x] Setup new es2 instance with Nginx onboard
- [x] Forgot  provision instance with python-minimal and ansible packeges
￼
    - [x] Create new Security group
        - [x] Open 22, 80, 443 ports
    - [ ] Assign e Tags to instance
    - [ ] I will provision Ubuntu box with Ansible playbook
    - [ ] With sample data
￼
- [x] Create new ssh pem file
- [x] Create new directory assign chmod  500 for directory
- [x] Assign 400 to pem file
- [x] “/Users/dmytrosymonenko/Desktop/mentoring/mentoring_Demo/jenkins/.ssh/tech_task.pem”
- [x] Edit inventory file for Ansible _ add IP and ssh key file
- [x] Provision with ansible “ ansible-playbook -i inventory simple_nginx.yml ”

*****************************************************************************************************
“Ansible  output ”

PLAY [Install nginx playbook] ******************************************************************************************************************************

TASK [Gathering Facts] *************************************************************************************************************************************
ok: [NGINX]

TASK [Install nginx from apt] ******************************************************************************************************************************
changed: [NGINX] => (item=[u'nginx', u'unzip', u'zip', u'htop'])

TASK [Check if nginx  is up] *******************************************************************************************************************************
ok: [NGINX]

TASK [download Zabix agent] ********************************************************************************************************************************

changed: [NGINX]

TASK [install all.deb] *************************************************************************************************************************************
changed: [NGINX]

TASK [update_cahe] *****************************************************************************************************************************************
changed: [NGINX]

TASK [install latest zabix agent] **************************************************************************************************************************
changed: [NGINX]

TASK [templeate for zabbix-agent] **************************************************************************************************************************
changed: [NGINX]

TASK [Ensure zabbix is started and enabled] ****************************************************************************************************************
changed: [NGINX]

RUNNING HANDLER [Restart zabbix-agent] *********************************************************************************************************************
changed: [NGINX]

TASK [copy content for Nginx] ******************************************************************************************************************************
changed: [NGINX]

TASK [Extract nginx_data.zip into /var/www/html] ***********************************************************************************************************
changed: [NGINX]

PLAY RECAP *************************************************************************************************************************************************
NGINX                      : ok=12   changed=10   unreachable=0    failed=0   

- [x]  Ensure that everything is working
- [x] Assign A-addres Epam.tk to IP address
- [x] Create IMAGE from Primary node instance
- [x] Replicate them 2-ss
- [x] Assign all a-names  
￼
———————————————————————————————————————

First part is ready


Prerequisites:

- [x] Create three A-records for the custom domain (like a.domain.com, b.domain.com, c.domain.com). If you don’t have one, please register free in pp.ua zone.
- [x] Point them to three EC2 instances: 2xEC2 should be running, 1xEC2 should be in stopped state.

Task definition:

Write a Shell/Python script using AWS SDK that will do the following:

- [x] Determinate the instance state using it’s DNS name (need at least 2 verifications, TCP and HTTP).
    - [x] Wrote bash script with will get DNS name or IP and will check 22 tcp port and HTTP port
    - [x]
- [x] Create an AMI of the stopped EC2 instance, add descriptive tag based on the EC2 name along with the current date.
- [x] Terminate stopped EC2 after AMI creation.
- [x] Clean up AMIs older than 7 days for the specific availability zone, where terminated instance was running.
- [x] Print all instances in fine-grained output, INCLUDING terminated one, with highlighting their current state.
