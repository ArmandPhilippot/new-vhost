# newVhost

Create a new Apache VirtualHost on Manjaro Linux, and, probably the other distributions using `httpd`.

## Requirements

- [LAMP](https://wiki.archlinux.fr/LAMP)
- [Manjaro](https://manjaro.org/) and probably the other distributions using `httpd`
- [mkcert](https://github.com/FiloSottile/mkcert)

## Use

**The script must be executed with administrator rights (sudo).**

Run the script in a terminal using `sudo sh filename.sh`.

The script will ask you for more information before executing:

- the username of your Linux session,
- the path of your working directory (example /home/username/Websites),
- the vhost name preferably with the TLD (example my-new-vhost.test).

The script will :

- create the VirtualHost configuration file in `/etc/httpd/conf/vhosts/`,
- include the configuration in `/etc/httpd/conf/httpd.conf`,
- generate the working folder for your VirtualHost and give it the right rights,
- create a folder `/home/username/.local-certificates`,
- generate a certificate for this VirtualHost in the folder created previously and give it corrects permissions,
- create a symbolic link between the working folder and the Apache directory (`/srv/http/`),
- add a line in the hosts file `/etc/hosts`.

## Disclaimer

I use this script on my Manjaro distribution to save time. I understand what it does. If you do not know how to create a VirtualHost, I advise you to learn how to do it before using this script.

This script is designed to be used for a development environment. I do not recommend using it for a production environment.

This script will probably work for distributions using `httpd` and not `apache2`, but I have not tested it elsewhere than on Manjaro. Make sure the paths specified in the script exist before using it.

## Changelog

| Date       | Notes                                         |
| :--------- | :-------------------------------------------- |
| 2020-05-27 | Translation of instructions in English.       |
| 2020-03-17 | Initial version - No history, formerly a gist |

## License

This script is licensed under the MIT license. A copy of the license is included in the root of the script’s directory. The file is named LICENSE.
