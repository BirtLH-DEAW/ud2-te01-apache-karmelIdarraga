# Ejemplo de fichero Dockerfile
# Crea una nueva imagen a partir de httpd, verisón 2.4

FROM ubuntu/apache2:2.4-22.04_beta

# Da información sobre la imagen que estamos creando
# Podemos usar la \ para encadenar todos los valores
LABEL \
	authors="kidarraga" \
	version="1.0" \
	description="Ubuntu + Apache2 + ssl + nano + web" \
	creationDate="12-11-2024"

# Ejecutamos diferentes comandos
# Debemos encadenarlos en un mismo RUN mediante la \
RUN \
	apt-get update \
	&& apt-get -y install nano \
	&& apt-get -y install openssl \
	&& openssl genpkey -algorithm RSA  -out /etc/ssl/private/kidarraga-server.key \
	&& openssl req -new -key /etc/ssl/private/kidarraga-server.key -x509 -days 365 -out /etc/ssl/certs/kidarraga-server.pem  -subj "/C=EU/ST=Bizkaia/L=Mungia/O=Karmel Idarraga/CN=www.kidarraga-birt.eus/emailAddress=kidarraga@birt.eus" \
	&& a2enmod ssl \
	&& a2ensite default-ssl.conf \
	&& htpasswd -cb /etc/apache2/.htpasswd deaw deaw

# Podemos copiar todos los ficheros que ncesitemos
COPY copia_web /var/www/html/
COPY sites-available /etc/apache2/sites-available

# Indica el puerto que utiliza la imagen
# para que lo mapeemos al crear el contenedor
EXPOSE 80
EXPOSE 443

# Si los ficheros están en la nube o comprimidos en un TAR
# podemos usar ADD
# ADD URL o TAR dir_destino

# Variables de entorno para la imagen
# ENV MYSQL_ROOT_PASSWORD root