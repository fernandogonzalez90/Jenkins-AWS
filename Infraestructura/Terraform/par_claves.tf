resource "aws_key_pair" "deployer" {
  key_name   = "jenkins_key"
  public_key = file("clave.pub")
}