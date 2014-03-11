#Cricket

Cricket is an easy to use and (hopefully) easy to setup issue tracker. Here are some of crickets key features

- Easy to setup (no configuration needed after installation)
- LDAP support
- Easy to include in your apps to gather user feedback

##Setup cricket

###1. Install ruby (preferrably via RVM)

If you dont have ruby installed on your server - do so. 

I recommend using [RVM](https://rvm.io/rvm/install/) and installing it as root.
Before you install RVM, install `build-essential` (gcc, make, etc.).
Then follow the onscreen instructions of the RVM installer. If anything concerning ruby and the gem package manager
goes wrong hereafter, follow these steps, run `rvm requirements` and install the packages needed. Then Reinstall ruby using `rvm reinstall 1.9.3`.



If you dont install ruby using rvm make sure to install a ruby version >= 1.9.2

Try running this to validate that everything went right after installing

	ruby -v

###2. Install bundler and cricket dependencies

Assuming that you already have downloaded cricket, here are the next steps:
You might have to sudo the following steps:

	gem install bundler
	cd /path/to/cricket
	bundle install
	
###3. Install passenger

Passenger is an apache module, you can use to run rails applications (like cricket) on apache. Run the following commands and follow the
on-screen instructions.

	gem install passenger
	passenger-install-apache2-module

###4. Install cricket on a subdomain or as a subdirectory

Create the following site-configuration for apache to use cricket on a subdomain of your server:

	<VirtualHost *:80>
	  ServerName cricket.yourserver.tld
	  DocumentRoot /path/to/cricket/public
	</VirtualHost>
	
If you want to run cricket on a subdirectory of your server - like yourserver.tld/cricket - follow [these](http://www.modrails.com/documentation/Users%20guide%20Apache.html#deploying_rails_to_sub_uri) instructions.

You might have to restart apache for changes to be effective

###5. Setup cricket for apache use

	cd /path/to/cricket
	chmod -R 777 db/ log/ tmp/		
	rake assets:precompile	
	#RAILS_ENV=production	rake db:migrate
	#RAILS_ENV=production	rake db:reset
	#chmod -R 777 db/
	
Restart apache and you should be ready to go.
	
