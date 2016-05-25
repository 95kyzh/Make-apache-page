#!/bin/bash
if ! [ -d /etc/apache2/ ];then
	sudo apt-get install apache2
fi
> secciones.txt
echo "Nombre del dominio: "
read dom
echo "Numero de secciones del dominio: "
read nsec
for i in `seq 1 $nsec`;do
	echo "Seccion: "
	read sec
	echo $sec >> secciones.txt
done

mkdir /var/www/$dom
touch /var/www/$dom/index.html
echo "<html>" >> /var/www/$dom/index.html
echo "<p> Hola </p>" >> /var/www/$dom/index.html
echo "</html>" >> /var/www/$dom/index.html
for i in `seq 1 $nsec`;do
	sec=$(head -$i secciones.txt | tail -1)
	mkdir /var/www/$sec
	touch /var/www/$sec/index.html
	echo "<html>" >> /var/www/$sec/index.html
	echo "<p> Hola </p>" >> /var/www/$sec/index.html
	echo "</html>" >> /var/www/$sec/index.html
done

touch /etc/apache2/sites-available/$dom.conf
touch /etc/apache2/sites-available/www$dom.conf
for i in `seq 1 $nsec`;do
	sec=$(head -$i secciones.txt | tail -1)
	touch /etc/apache2/sites-available/$sec.conf
done

echo "<VirtualHost *:80>" >> /etc/apache2/sites-available/$dom.conf
echo "ServerAdmin webmaster@localhost" >> /etc/apache2/sites-available/$dom.conf
echo "DocumentRoot /var/www/$dom" >> /etc/apache2/sites-available/$dom.conf
echo "ServerName $dom" >> /etc/apache2/sites-available/$dom.conf
echo "ErrorLog /var/log/apache2/error.log" >> /etc/apache2/sites-available/$dom.conf
echo "</VirtualHost> " >> /etc/apache2/sites-available/$dom.conf
a2ensite $dom.conf

echo "<VirtualHost *:80>" >> /etc/apache2/sites-available/www$dom.conf
echo "ServerAdmin webmaster@localhost" >> /etc/apache2/sites-available/www$dom.conf
echo "DocumentRoot /var/www/$dom" >> /etc/apache2/sites-available/www$dom.conf
echo "ServerName www.$dom" >> /etc/apache2/sites-available/www$dom.conf
echo "ErrorLog /var/log/apache2/error.log" >> /etc/apache2/sites-available/www$dom.conf
echo "</VirtualHost> " >> /etc/apache2/sites-available/www$dom.conf
a2ensite www$dom.conf

for i in `seq 1 $nsec`;do
	sec=$(head -$i secciones.txt | tail -1)
	echo "<VirtualHost *:80>" >> /etc/apache2/sites-available/$sec.conf
	echo "ServerAdmin webmaster@localhost" >> /etc/apache2/sites-available/$sec.conf
	echo "DocumentRoot /var/www/$sec" >> /etc/apache2/sites-available/$sec.conf
	echo "ServerName $sec" >> /etc/apache2/sites-available/$sec.conf
	echo "ErrorLog /var/log/apache2/error.log" >> /etc/apache2/sites-available/$sec.conf
	echo "</VirtualHost> " >> /etc/apache2/sites-available/$sec.conf
	a2ensite $sec.conf
done
service apache2 reload
rm secciones.txt
echo "Finalmente configure su archivo Hosts"

