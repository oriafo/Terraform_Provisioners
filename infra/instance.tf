terraform {
    backend "s3" {
    bucket         = "oriafostatebbucket"
    key            = "infraa.tfstate"
    region         = "us-east-1"         
    dynamodb_table = "ab-provisioner-lock"    
    encrypt        = true                  
  }

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
      "chmod +x /home/ubuntu/web.sh", # Make the file executable
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

