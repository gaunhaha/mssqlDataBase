FROM mcr.microsoft.com/mssql/server:2022-latest

ENV ACCEPT_EULA=Y
ENV MSSQL_SA_PASSWORD=YourPassword123!
ENV MSSQL_TCP_PORT=1433
ENV MSSQL_PID=Developer

USER root

RUN mkdir -p /var/lib/apt/lists/partial && \
    apt-get update && \
    apt-get install -y curl apt-transport-https gnupg && \
    curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    curl https://packages.microsoft.com/config/ubuntu/20.04/prod.list > /etc/apt/sources.list.d/mssql-release.list && \
    apt-get update && ACCEPT_EULA=Y apt-get install -y msodbcsql17 mssql-tools && \
    echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc

COPY init.sql /var/opt/mssql/scripts/
COPY entrypoint.sh /var/opt/mssql/scripts/

RUN chmod +x /var/opt/mssql/scripts/entrypoint.sh

USER mssql

CMD ["/var/opt/mssql/scripts/entrypoint.sh"]