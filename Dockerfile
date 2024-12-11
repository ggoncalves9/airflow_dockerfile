# Usando a imagem base do Python 3.7 slim
FROM python:3.7-slim-buster

# Instalando dependências necessárias
RUN set -ex; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        build-essential \
        default-libmysqlclient-dev \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg \
        libssl-dev \
        libkrb5-dev \
        libsasl2-dev \
        libffi-dev \
        libpq-dev \
        git \
        locales \
        lsb-release \
        sasl2-bin \
        sqlite3 \
        unixodbc-dev \
        gosu; \
    rm -rf /var/lib/apt/lists/*

# Configurando a localidade para en_US.UTF-8
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

# Instalando o Apache Airflow
ARG AIRFLOW_VERSION=2.1.0
ARG CONSTRAINT_URL="https://raw.githubusercontent.com/apache/airflow/constraints-${AIRFLOW_VERSION}/constraints-3.7.txt"
RUN pip install "apache-airflow==${AIRFLOW_VERSION}" --constraint "${CONSTRAINT_URL}"

# Criando diretórios necessários
RUN mkdir -p /usr/local/airflow/dags /usr/local/airflow/logs /usr/local/airflow/plugins

# Definindo variáveis de ambiente
ENV AIRFLOW_HOME=/usr/local/airflow

# Definindo o ponto de entrada
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

# Expondo a porta do Airflow WebServer
EXPOSE 8080

# Comando padrão para iniciar o webserver
CMD ["webserver"]
