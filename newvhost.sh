#! /bin/bash
# newvhost.sh
# Script to create a new vhost in Apache.
# Originally written by Armand Philippot <contact@armandphilippot.com>.

###############################################################################
#
# MIT License

# Copyright (c) 2020 Armand Philippot

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#
###############################################################################

echo -e "This script allows you to automatically create a new vhost in Apache.\n"
echo -e "The script must be executed with administrator rights (sudo).\n"
echo -e "It is best to use this script only for a local development environment.\n"

# We are testing whether Apache is installed. If it is not, we stop the script.
if command -v httpd &>/dev/null; then
  echo -e "Apache is installed, let's continue."
else
  echo -e "Apache is not installed.\n"
  exit 2
fi

if command -v mkcert &>/dev/null; then
  echo -e "mkcert is installed, let's continue.\n"
else
  echo -e "mkcert is not installed. It is necessary to generate a certificate allowing access in https. Please install it and try again.\n"
  exit 2
fi

# We ask for the username to grant the correct permissions to the created folders.
read -rp "Enter your username: " _username

read -rp 'Enter the path of the working folder: ' _basedir
if [ -d "$_basedir" ]; then
  echo -e "The folder exists, let's continue.\n"
  [[ "${_basedir}" != */ ]] && _basedir="${_basedir}/"
else
  until [ -d "$_basedir" ]; do
    echo -e "The folder does not exist. Please enter a valid path.\n"
    read -rp 'Enter the path of the working folder: ' _basedir
  done
fi

# We ask for the name to use to create the virtual host (preferably with a TLD).
read -rp 'Enter the name of the vhost to create: ' _vhost

# We create the configuration file for the virtual host then we create the working folders. We grand correct permissions and we create a symlink in Apache folder.
if command -v httpd &>/dev/null; then
  if [ -d "/etc/httpd/conf/vhosts/$_vhost" ]; then
    echo -e "The vhost already exists.\n"
    exit 2
  else
    cat <<-EOF >/etc/httpd/conf/vhosts/"${_vhost}"
<VirtualHost *:80>
    ServerAdmin webmaster@${_vhost}
    DocumentRoot "/srv/http/${_vhost}/htdocs/"
    ServerName www.${_vhost}
    ServerAlias *.${_vhost}
    ErrorLog "/srv/http/${_vhost}/logs/error.log"
    CustomLog "/srv/http/${_vhost}/logs/access.log" combined
    <Directory /srv/http/${_vhost}/htdocs/>
        Options -Indexes +FollowSymLinks +MultiViews
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>

<VirtualHost *:443>
    ServerAdmin webmaster@${_vhost}
    DocumentRoot "/srv/http/${_vhost}/htdocs/"
    ServerName www.${_vhost}:443
    ServerAlias *.${_vhost}:443
    SSLEngine on
    SSLCertificateFile "/home/${_username}/.local-certificates/${_vhost}.pem"
    SSLCertificateKeyFile "/home/${_username}/.local-certificates/${_vhost}-key.pem"
    ErrorLog "/srv/http/${_vhost}/logs/error.log"
    CustomLog "/srv/http/${_vhost}/logs/access.log" combined
    <Directory /srv/http/${_vhost}/htdocs/>
        Options -Indexes +FollowSymLinks +MultiViews
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
EOF
    mkdir -p "${_basedir}/${_vhost}/htdocs"
    mkdir -p "${_basedir}/${_vhost}/logs"
    chown -R "${_username}:${_username}" "${_basedir}/${_vhost}"
    chmod -R 755 "${_basedir}/${_vhost}"
    ln -s "${_basedir}${_vhost}"/ /srv/http/
    echo "Include conf/vhosts/${_vhost}" >>/etc/httpd/conf/httpd.conf
    mkdir -p "/home/${_username}/.local-certificates"
    mkcert -cert-file "/home/${_username}/.local-certificates/${_vhost}.pem" -key-file "/home/${_username}/.local-certificates/${_vhost}-key.pem" "${_vhost}" "*.${_vhost}"
    chown -R ${_username}:${_username} /home/${_username}/.local-certificates/${_vhost}.pem
    chown -R ${_username}:${_username} /home/${_username}/.local-certificates/${_vhost}-key.pem
  fi
fi

# We add a line in the hosts file.
echo "127.0.0.1 www.${_vhost}" >>/etc/hosts
echo -e "The vhost and the corresponding folders have been created.\n"

# We display the folders so that the user can verify the creation of the virtual host.
if command -v httpd &>/dev/null; then
  ls /srv/http/
fi
echo -e "\nYou can access it by entering ${_vhost} or www.${_vhost} in your browser.\n"

# If Apache is running, we restart it.
systemctl is-active --quiet httpd && echo -e "We restart Apache.\n" && systemctl restart httpd

echo -e "End of script.\n"
