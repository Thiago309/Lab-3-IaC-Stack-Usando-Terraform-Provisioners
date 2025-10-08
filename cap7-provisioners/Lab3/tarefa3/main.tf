# Utilizando o recurso de grupo de seguranças nomeando a função como (permite_ssh)
resource "aws_security_group" "permite_ssh" {
  
  # Nome do grupo de seguranças
  name = "permite_ssh"
  
  # Descrição do grupo de seguranças
  description = "Security Group EC2 Instance"

  # Regra de entrada para a rede AWS.
  ingress {

    description = "Inbound Rule"
    # Intervalos de portas de acesso 22 - 80 
    from_port = 22
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  # Regra de saída para a rede AWS.
  egress {

    description = "Outbound Rule"
    # Intervalos de portas de acesso 0 - 65535 
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
}

resource "aws_instance" "dsa_instance" {
  
  ami = "ami-0a0d9cf81c479446a"  
  
  instance_type = var.instance_type
  
  # Pôr o mesmo nome do par de chaves criada no ambiente AWS para poder realizar a associação
  # dessas credencias com a chave privada (dsa-lab3.pem) e realizar a conexão com a instância EC2.
  key_name = "dsa-lab3"

  tags = {
    Name = "lab3-t2-terraform"
  }

  # Criando um provisioner do tipo remote-exec, para realizar uma conexão SSH e 
  # executar um script ou um conjunto de comandos em um recurso remoto
  provisioner "remote-exec" {
    
    # Bloco 1: Lista de comandos shell linux.
            # 1º Comando: Atualiza o Sistema Operacional. -y (significa yes, confirma automaticamente as perguntas)
    inline = ["sudo yum update -y", 
            # 2º Comando: Instala o Apache 2 (httpd) que é um serviço web.
              "sudo yum install httpd -y", 
            # 3º Comando: Inicia o Apache 2 (httpd).
              "sudo systemctl start httpd", 
            # 4º Comando: Executa o bash dentro da instância EC2 e executa o comando echo para criar a frase abaixo, e salvar dentro do arquivo html.
              "sudo bash -c 'echo Criando o Segundo Web Server com Terraform na DSA > /var/www/html/index.html'"]

    # Bloco 2: Realizar conexão com a instância via SSH.
    connection {
      # Tipo de conexão.
      type     = "ssh"
      # O tipo de usuario depende da AMI da instância que você está utilizando. Nesse exemplo estou utilizando para a (ami-0a0d9cf81c479446a). 
      # Caso queira mudar de usuario é aconselhavel consultar a documentação das AMI's no site de AWS. 
      user     = "ec2-user"
      # Indica o arquivo com a chave privada para realizar a conexão com a EC2.
      private_key = file("dsa-lab3.pem")
      # Endereço para realizar a conexão com a instância EC2. Recebe o valor do IP atraves da função output "public_ip" que está no arquivo outputs.tf .
      host     = self.public_ip
    }
  }
}