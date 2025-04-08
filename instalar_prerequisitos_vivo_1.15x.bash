#!/bin/bash
#script automatizado que instala los prerequisitos necesarios para VIVO 1.15 en Ubuntu 24.04.2 LTS, 
#excepto Solr, vivocore y la creación de usuarios de base de datos.
#También incluye validaciones simples al final de cada instalación e informe de resumen llamado 
#informe_instalacion_vivo.txt al final del proceso

LOG_FILE="/opt/informe_instalacion_vivo.txt"
echo "=== Informe de instalación de prerequisitos para VIVO ===" | sudo tee $LOG_FILE > /dev/null
echo "Fecha: $(date)" | sudo tee -a $LOG_FILE > /dev/null
echo "" | sudo tee -a $LOG_FILE > /dev/null

echo ">> Actualizando sistema..."
sudo apt update && sudo apt upgrade -y

# -------------------------------
# 1. Instalar Java 11
# -------------------------------
echo ">> Instalando Java 11..."
sudo apt install openjdk-11-jdk -y

JAVA_HOME_PATH="/usr/lib/jvm/java-11-openjdk-amd64"
echo ">> Configurando JAVA_HOME..."
if ! grep -q "JAVA_HOME" /etc/profile; then
    echo "export JAVA_HOME=$JAVA_HOME_PATH" | sudo tee -a /etc/profile
    echo 'export PATH=$JAVA_HOME/bin:$PATH' | sudo tee -a /etc/profile
    source /etc/profile
fi

echo -n ">> Validando Java: "
if java -version &>/dev/null; then
    echo "✔️ Java instalado correctamente"
    echo "Java: ✔️ OK" | sudo tee -a $LOG_FILE > /dev/null
else
    echo "❌ Error al instalar Java"
    echo "Java: ❌ ERROR" | sudo tee -a $LOG_FILE > /dev/null
fi

# -------------------------------
# 2. Instalar Maven
# -------------------------------
echo ">> Instalando Maven..."
sudo apt install maven -y

echo -n ">> Validando Maven: "
if mvn -version &>/dev/null; then
    echo "✔️ Maven instalado correctamente"
    echo "Maven: ✔️ OK" | sudo tee -a $LOG_FILE > /dev/null
else
    echo "❌ Error al instalar Maven"
    echo "Maven: ❌ ERROR" | sudo tee -a $LOG_FILE > /dev/null
fi

# -------------------------------
# 3. Instalar Tomcat 9
# -------------------------------
echo ">> Creando usuario tomcat..."
sudo useradd -m -d /opt/tomcat -U -s /bin/false tomcat

echo ">> Descargando Tomcat 9..."
cd /tmp
wget https://downloads.apache.org/tomcat/tomcat-9/v9.0.102/bin/apache-tomcat-9.0.102.tar.gz

echo ">> Descomprimiendo Tomcat..."
sudo tar -xvzf apache-tomcat-9.0.102.tar.gz -C /opt/tomcat --strip-components=1

echo ">> Asignando permisos..."
sudo chown -R tomcat:tomcat /opt/tomcat
sudo chmod -R 755 /opt/tomcat

echo ">> Creando servicio systemd para Tomcat..."
sudo tee /etc/systemd/system/tomcat.service > /dev/null <<EOF
[Unit]
Description=Apache Tomcat 9
After=network.target

[Service]
Type=forking

User=tomcat
Group=tomcat

Environment="JAVA_HOME=$JAVA_HOME_PATH"
Environment="CATALINA_PID=/opt/tomcat/temp/tomcat.pid"
Environment="CATALINA_HOME=/opt/tomcat"
Environment="CATALINA_BASE=/opt/tomcat"
ExecStart=/opt/tomcat/bin/startup.sh
ExecStop=/opt/tomcat/bin/shutdown.sh
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

echo ">> Habilitando y arrancando Tomcat..."
sudo systemctl daemon-reload
sudo systemctl enable tomcat
sudo systemctl start tomcat

echo -n ">> Validando Tomcat: "
if sudo systemctl is-active --quiet tomcat; then
    echo "✔️ Tomcat activo"
    echo "Tomcat: ✔️ OK" | sudo tee -a $LOG_FILE > /dev/null
else
    echo "❌ Error al iniciar Tomcat"
    echo "Tomcat: ❌ ERROR" | sudo tee -a $LOG_FILE > /dev/null
fi

# -------------------------------
# 4. Instalar MySQL Server
# -------------------------------
echo ">> Instalando MySQL Server..."
sudo apt install mysql-server -y

echo -n ">> Validando MySQL: "
if sudo systemctl is-active --quiet mysql; then
    echo "✔️ MySQL activo"
    echo "MySQL: ✔️ OK" | sudo tee -a $LOG_FILE > /dev/null
else
    echo "❌ Error al iniciar MySQL"
    echo "MySQL: ❌ ERROR" | sudo tee -a $LOG_FILE > /dev/null
fi

# Final
echo ""
echo "=== Instalación finalizada ==="
echo "📄 Informe guardado en: $LOG_FILE"

