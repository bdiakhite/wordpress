#!/bin/bash

sudo apt-get install -y apache2
sudo apt-get install -y php7.0
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password 0000'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password 0000'
sudo apt-get -y install mysql-server
sudo apt-get install -y php7.0-mysql
sudo apt-get install -y libapache2-mod-php7.0

mysql -uroot -p0000 -e"create database wordpress;"
mysql -uroot -p0000 -e"use wordpress;"


cd /var/www/html
rm index.html

curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
sudo chmod 777 wp-cli.phar
sudo mv wp-cli.phar /usr/local/bin/wp
sudo service apache2 restart
sudo chmod 777/usr/local/bin/wp

wp core download

wp config create --dbname=wordpress --dbuser=root --dbpass=0000 --allow-root

echo 'quel est le nom que vous souhaitez donner à votre site ?'; 
read namesite;

echo 'choisissez votre identifiant';
read adminUser;

echo 'puis votre mot de passe';
read password;


wp core install --url=192.168.33.10 --title=$namesite --admin_user=$adminUser --admin_password=$password --admin_email=admin@admin.fr


echo "WESH t'as fait un super site YOLOOOOOOOWWWWW !!!!"

themes () {
echo "1 ajouter un thème    2 supprimer un thème       3 afficher la liste des thèmes     4 quitter";

select response in "1" "2" "3" "4";do
  case $response in
    "1" ) echo "quel thème voulez-vous ajouter: ";
          read theme;
          wp theme install $theme;
          wp theme activate $theme;
    ;;
    "2" ) echo "quel plugin voulez-vous supprimer: ";
          read theme;
          wp theme delete $theme;
    ;;
    "3" ) wp theme list;
    ;;
    "4" ) break;;
  esac
done
}

plugins () {
echo "1 ajouter un plugin     2 supprimer un plugin     3 liste des plugins     4 quitter";

select response in "1" "2" "3" "4";do
  case $response in
    "1" ) echo "quel plugin voulez-vous ajouter: ";
                read plugin;
                echo "voulez-vous l'activer (o/n)";
                read act;
                wp plugin install $plugin;
                if (($act == "o"))
                then
                    wp plugin activate $plugin;
                fi                
    ;;
    "2" ) echo "quel plugin voulez-vous supprimer: ";
                  read plugin;
                  echo "êtes vous sûr(e) de vouloir le supprimer (o/n)";
                  read act; 
                  if (($act == "o"))
                  then
                    wp plugin delete $plugin;
                  fi
    ;;
    "3" ) wp plugin list;
    ;;
    "4" ) break;;
  esac
done
}


response="";
echo 'menu principal: '
echo "1 plugins 2 thèmes"

select response in "1" "2"; do
  echo 'menu principal: '
  echo "1 plugins 2 thèmes"
  case $response in
    "1" ) plugins ;
  ;;
    "2" ) themes ;
  ;;
  esac
done

