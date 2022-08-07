# terraform-ec2

### Important Points

    * EC2 or SG will be created in the default VPC if you don't mention the VPC Specific
    * EC2 & SG should be created in the terraform provisioned VPC from the terraform-vpc created terraform code

### How can we achieve reading / fetching the information from a REMOTE STATE FILE
```
    * If something / some property hsa to be fetched by "X" repo from "Y" repo , then the requested information should be first available 
      on the STATE-FILE as OutPut
      
    * Output not only helps to print the output, but also helps us to read /share the information to others
```