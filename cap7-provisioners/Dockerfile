# Usar a imagem oficial do sistema operacional Linux Ubuntu na ultima versão como base da imagem
FROM ubuntu:latest

# Mantenedor da imagem
LABEL maintainer="Thiago_Vinicius"

# Definir a versão do Terraform ultima versão sem ser beta (evita bugs e erros)
ENV TERRAFORM_VERSION=1.13.3

# Atualizar os pacotes do sistema e instalar dependências necessarias (wget, curl, unzip, tree para visualização, gpg para a chave do GitHub)
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    wget \
    unzip \
    curl \
    tree \
    gpg \
    vim \
    ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Baixar e instalar Terraform
RUN wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    mv terraform /usr/local/bin/ && \
    rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# Instalar o AWS CLI em uma pasta temporária /tmp/ e a limpa no final, o que é mais eficiente.
RUN mkdir -p /tmp/aws_install && \
    cd /tmp/aws_install && \
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    cd / && \
    rm -rf /tmp/aws_install

# Adicionar repositório e instalar a CLI do GitHub (gh)
RUN mkdir -p -m 755 /etc/apt/keyrings && \
    wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null && \
    chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null && \
    apt-get update && \
    apt-get install gh -y

# Criar a pasta /IaC-AWS dentro do container
RUN mkdir /IaC-AWS

# Copiar os arquivos local para o diretorio de trabalho no contêiner
COPY . /IaC-AWS/

# Definir o diretório de trabalho padrão
WORKDIR /IaC-AWS

# Definir o comando padrão para execução quando o container for iniciado
CMD ["/bin/bash"]