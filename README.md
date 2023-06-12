# Three Tiered Application Assignment

This project deploys and configures a three tiered application using Terraform and Ansible.

After running:
    ```
    terraform init
    ```
    ```
    terraform plan
    ```
    ```
    terraform apply
    ```
    
The following will be added to your AWS account:

1. A VPC for the application servers
2. A Subnet for the application servers
3. Security Groups that enforce the following network segmentation:
        i.  Allow from the workstation to the LB server on port 80
        ii.  Allow from the workstation to all the servers on port 22
        iii.  Allow any internal communication in the subnet
        iv.  Block everything else
4.  An internet gateway to allow assignment servers to access the internet.
5.  Three instances of type t2.micro on AWS EC2:  (ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server) - LB, WEB, DB

The Ansible playbook configures the three tiered application.

Browse to the url http://<LB-PUBLIC-IP>/Test/ of the LB server - In our case it will be 

    http://3.97.8.60/Test/

 And congrats, you re connected to MongoDB Server through the three tiered application!