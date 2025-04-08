# ca-repo-cros
Repositorio de Ciencia Abierta Vivo, Dspace

Ayuda para instalar_prerequisitos_vivo_1.15x.bash

🧩 Requisitos de sistema para la implementación de VIVO 1.15.x
Este script instala los prerrequisitos esenciales para ejecutar el sistema web VIVO 1.15.x, probados en: 🐧 Ubuntu Server 24.04.2 LTS

📄 Guía oficial de requerimientos del sistema: https://wiki.lyrasis.org/display/VIVODOC115x/System+Requirements

🛠️ Componentes que instala
☕ Java 11 (JDK) + configuración de JAVA_HOME
🔧 Apache Maven 3.8.7
🐱 Apache Tomcat 9.0.102
🐬 MariaDB Server (última versión disponible en repositorio oficial)

📦 Cómo usar este script
Paso 1: Descargar el archivo 
wget https://github.com/alberto-crosthwaite/ca-repo-cros/blob/main/instalar_prerequisitos_vivo_1.15x.bash

Paso 2: Dar permisos de ejecución 
chmod +x instalar_prerequisitos_vivo.sh

Paso 3: Ejecutar como superusuario 
sudo ./instalar_prerequisitos_vivo.sh

📄 Informe de instalación
Al finalizar, se genera un archivo con el resumen de la instalación en: /opt/informe_instalacion_vivo.txt

Ejemplo de salida:
=== Informe de instalación de prerequisitos para VIVO ===
Fecha: Wed Apr  2 22:51:42 UTC 2025
Java:   ✔️ OK
Maven:  ✔️ OK
Tomcat: ✔️ OK
MySQL:  ✔️ OK


⚠️ Notas importantes
Este script no instala Solr, ni vivocore ya que se recomienda configurarlo manualmente.

La creación de usuarios y bases de datos en MySQL/MariaDB debe realizarse manualmente según las necesidades del proyecto.



