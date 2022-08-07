resource "aws_instance" "student" {
  ami                     = var.AMI_ID
  instance_type           = "t2.micro"
  subnet_id               = data.terraform_remote_state.vpc.outputs.PUB_SUBNET[0]
  key_name                = "lab"
  vpc_security_group_ids  = [aws_security_group.allow_ssh.id]

  tags = {
    Name = "${var.PROJECTNAME}-${var.ENV}-WebApp"
  }

# Copies the private key file as the centos user using SSH
provisioner "file" {
  source      = "/var/lib/jenkins/.ssh/id_rsa"
  destination = "/home/centos/.ssh/id_rsa"

  connection {
    type        = "ssh"
    user        = "centos"
    private_key = "${file("/var/lib/jenkins/.ssh/id_rsa")}"
    host        = aws_instance.student.private_ip
     }
   }

provisioner "remote-exec" {
  connection {
    type        = "ssh"
    user        = "centos"
    private_key = "${file("/var/lib/jenkins/.ssh/id_rsa")}"
    host        = aws_instance.student.private_ip
     }

    inline = [
      "echo -e 'Host * \n \t StrictHostKeyChecking no' > /home/centos/.ssh/config",
      "chmod 600 /home/centos/.ssh/id_rsa  /home/centos/.ssh/config",
      "sudo yum install ansible git -y",
      "ansible-pull -U git@gitlab.com:clouddevops-b47/ansible.git stack-pull.yml -e DBUSER=student  -e DBPASS=student1 -e DBNAME=studentapp"
    ]
  }
}


# Preserving the Private Ip in a file which can be consumed by ANSIBLE 
resource "local_file" "private_ip" {
    content  = "${aws_instance.student.private_ip}"
    filename = "/tmp/tf-hosts"
}