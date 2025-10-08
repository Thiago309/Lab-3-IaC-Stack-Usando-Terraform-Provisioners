resource "aws_security_group" "permite_ssh_2" {
  
  name = "permite_ssh_2"
  
  description = "Security Group EC2 Instance"

  ingress {

    description = "Inbound Rule"
    from_port = 22
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {

    description = "Outbound Rule"
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

    }

}

resource "aws_instance" "dsa_instance" {
  
  ami = "ami-0a0d9cf81c479446a"  
  
  instance_type = var.instance_type

  vpc_security_group_ids = [aws_security_group.permite_ssh_2.id]
  
  key_name = "dsa-lab3"

  tags = {
    Name = "lab3-t4-terraform"
  }

# Esta utilizando o arquivo .sh para executar os comandos dentro da instancia EC2. Também informa o destino do arquivo.
  provisioner "file" {
    source      = "dsa_script.sh"
    # O diretorio /tmp/ é uma pasta padrão do linux. Ela existe independente de qualquer instancia linux que eu criar.
    # Por isso que é mais seguro por esse arquivo dentro dessa pasta temporaria.
    destination = "/tmp/dsa_script.sh"

    connection {
      type     = "ssh"
      user     = "ec2-user"
      private_key = file("../tarefa3/dsa-lab3.pem")
      host     = self.public_ip
    }
  }

  provisioner "remote-exec" {
    
    # [chmod] é o comando do linux que altera a permissão de privilegio de arquivos e pastas na instancia.
    #  O [+x] permite o privilegio de execução do script contido no arquivo dsa_script.sh
    inline = ["chmod +x /tmp/dsa_script.sh", "/tmp/dsa_script.sh"]

    connection {
      type     = "ssh"
      user     = "ec2-user"
      private_key = file("../tarefa3/dsa-lab3.pem")
      host     = self.public_ip
    }
  }
}
