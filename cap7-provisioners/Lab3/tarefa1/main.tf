
# "serviço que vou utilizar na aws" "nome da instancia a ser criada"
resource "aws_instance" "dsa_instance" {
  
  ami = "ami-0a0d9cf81c479446a"  
  
  instance_type = var.instance_type

  tags = {
    Name = "lab3-t1-terraform"
  }

# (palavra reservada) (tipo de provisioner)
  provisioner "local-exec" {
    # echo é o comando que imprime na tela. O $ retorna o valor da variavel. Salva o valor em um arquivo .txt
    command = "echo ${aws_instance.dsa_instance.public_ip} > ip_dsa_instance.txt"
  }
}
