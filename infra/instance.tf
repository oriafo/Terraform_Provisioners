terraform {
  #   backend "s3" {
  #   bucket         = "oriafostatebbucket"
  #   key            = "infraa.tfstate"
  #   region         = "us-east-1"         
  #   dynamodb_table = "ab-provisioner-lock"    
  #   encrypt        = true                  
  # }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}


resource "aws_key_pair" "pub_key" {
  key_name = "key"  # Replace with the name of your key pair
  public_key = file("key.pub")
}

resource "aws_instance" "provisioner_machine" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  #key_name      = data.aws_key_pair.my_key.key_name 
  key_name      = aws_key_pair.pub_key.key_name 
  tags = {
    Name = "provisioner_machine"
  }
  provisioner "file" {
    source      = "web.sh"                # Local file path
    destination = "/home/ubuntu/web.sh" # Destination on the instance
    connection {
      type        = "ssh"
      host        = self.public_ip
      user        = "ubuntu"
      private_key = file("key")  # Path to your SSH key
    }
  }

  provisioner "remote-exec" {
    inline = [
      #"sudo chown ubuntu:ubuntu /home/ubuntu/web.sh",
      "chmod +x /home/ubuntu/web.sh", # Make the file executable
      #"cd /home/ubuntu/",
      "/home/ubuntu/web.sh",         # Execute the file
    ]

    # Connect to the instance
    connection {
      type        = "ssh"
      host        = self.public_ip
      user        = "ubuntu"
      private_key = file("key")   # Path to your SSH key
    }
  }
}

# resource "aws_instance" "example" {
#   ami           = "ami-0c55b159cbfafe1f0" # Example AMI
#   instance_type = "t2.micro"

#   provisioner "file" {
#     source      = "local_file.txt"       # Local file path
#     destination = "/home/ec2-user/remote_file.txt" # Destination on the instance
#   }

#   provisioner "remote-exec" {
#     inline = [
#       "chmod +x /home/ec2-user/remote_file.txt",  # Make the file executable
#       "/home/ec2-user/remote_file.txt",             # Execute the file
#     ]

#     # Connect to the instance
#     connection {
#       type        = "ssh"
#       host        = self.public_ip
#       user        = "ec2-user"
#       private_key = file("~/.ssh/my_key.pem") # Path to your SSH key
#     }
#   }
# }