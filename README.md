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
        *  Allow from the workstation to the LB server on port 80
        *  Allow from the workstation to all the servers on port 22
        *  Allow any internal communication in the subnet
        *  Block everything else
4.  An internet gateway to allow assignment servers to access the internet.
5.  Three instances of type t2.micro on AWS EC2:  (ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server) - LB, WEB, DB

The Ansible playbook configures the three tiered application.

Browse to the url http://<LB-PUBLIC-IP>/Test/ of the LB server - In our case it will be 

    http://3.97.8.60/Test/

 And congrats, you re connected to MongoDB Server through the three tiered application!
    
    ![image](https://github.com/Yaichu/Akamai-assignment/assets/54328648/0772596d-5c98-46f4-81c0-66a3cf1efbe9)

    <img width="528" alt="Screenshot 2023-06-12 at 23 37 06" src="https://github.com/Yaichu/Akamai-assignment/assets/54328648/4a45577d-472a-4385-94d1-aa53ba3d7c86">

    
    
