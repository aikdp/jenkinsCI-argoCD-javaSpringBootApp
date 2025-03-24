#Importing existed public key (or u can chnge in the ec2, ~/.ssh/authrized_keys)
resource "aws_key_pair" "deployer" {
  key_name   = "jenkins"
  public_key = file("jenkins.pub")  //inporting already existed key pairs
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  vpc_security_group_ids = ["sg-0f487d954cbe820ef"]
  key_name = aws_key_pair.deployer.key_name     #id or key_name: attribute
  user_data = file("docker.sh")

  root_block_device {
    volume_size = 50
    volume_type = "gp3"
    delete_on_termination = true
  }

  tags = {
    Name = "ultimate-java-spring-boot"
  }
}