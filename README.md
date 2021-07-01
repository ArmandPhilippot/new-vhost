# new-vhost

Create a new Apache Virtual Host on Manjaro Linux, and, probably the other distributions using `httpd`.

## Requirements

- [LAMP](https://wiki.archlinux.fr/LAMP)
- [Manjaro](https://manjaro.org/) and probably the other distributions using `httpd`
- [mkcert](https://github.com/FiloSottile/mkcert)

## Use

Download `new-vhost` and make sure it as executable permission:

```bash
chmod +x new-vhost
```

Run the script in a terminal using `./new-vhost`.

The script will :
- ask you some information to configure your vhost (name, webroot, workspace, certs path)
- create a directory in your workspace named as your vhost and two subdirectory: one for the logs and another for the webroot,
- generate a local certificate in the certs path provided
- create the VirtualHost configuration file in `/etc/httpd/conf/vhosts/`,
- include the configuration in `/etc/httpd/conf/httpd.conf`,
- create a symbolic link between your vhost directory and the Apache directory (`/srv/http/`),
- add two lines in the hosts file `/etc/hosts` (with and without `www`).

## Disclaimer

I use this script on my Manjaro distribution to save time. I understand what it does. If you do not know how to create a VirtualHost, I advise you to learn how to do it before using this script.

This script is designed to be used for a development environment. I do not recommend using it for a production environment.

This script will probably work for distributions using `httpd` and not `apache2`, but I have not tested it elsewhere than on Manjaro. Make sure the paths specified in the script exist before using it.

## License

This script is open-source and licensed under the [MIT license](./LICENSE).
