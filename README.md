Nginx with PHP preinstalled
=========

	

This Image is used to deploy Web-Applications like TYPO3, Magento, Joomla etc


Permanent storage
-----------------

`/var/www/shared` should be used for all persistent files.



Configuration
-------------

- `PHP_SESSION_SAVE_HANDLER` Default: memcached
- `PHP_SESSION_SAVE_PATH` Default: memcache:11211
- `POSTFIX_HOSTNAME` Default: example.com
- `POSTFIX_PROTOCOL` Default: ipv4
- `POSTFIX_RELAYHOST` Default: ''

Directories used
----------------

- `/var/www/html` - Application Data
- `/var/www/shared` - Persistent Files

