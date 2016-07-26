# Introduction

Koha’s Plugin System (available in Koha 3.12+) allows for you to add additional tools and reports to [Koha](http://koha-community.org) that are specific to your library. Plugins are installed by uploading KPZ ( Koha Plugin Zip ) packages. A KPZ file is just a zip file containing the perl files, template files, and any other files necessary to make the plugin work. Learn more about the Koha Plugin System in the [Koha 3.22 Manual](http://manual.koha-community.org/3.22/en/pluginsystem.html) or watch [Kyle’s tutorial video](http://bywatersolutions.com/2013/01/23/koha-plugin-system-coming-soon/).

# Downloading

From the [release page](https://github.com/bywatersolutions/koha-plugin-kitchen-sink/releases) you can download the relevant *.kpz file

# Installing

Koha's Plugin System allows for you to add additional tools and reports to Koha that are specific to your library. Plugins are installed by uploading KPZ ( Koha Plugin Zip ) packages. A KPZ file is just a zip file containing the perl files, template files, and any other files necessary to make the plugin work.

The plugin system needs to be turned on by a system administrator.

To set up the Koha plugin system you must first make some changes to your install.

* Change `<enable_plugins>0<enable_plugins>` to `<enable_plugins>1</enable_plugins>` in your koha-conf.xml file
* Confirm that the path to `<pluginsdir>` exists, is correct, and is writable by the web server
* Restart your webserver

Once set up is complete you will need to alter your UseKohaPlugins system preference. On the Tools page you will see the Tools Plugins and on the Reports page you will see the Reports Plugins.

# Usage

This plugin was created as a way to authenticate Koha LDAP users into PALCI (via NCIP) using their Koha login in place of a barcode. The functionality of this plugin is to 1.) Log in a patron 2.) Capture their Koha card number from their logged in session and 3.) Pass that card number to the PALCI API URL.

PLEASE NOTE: YOUR INSTITUTION CODE MUST BE ADDED TO `palci-redirect.pl` IN ORDER FOR THE API URL TO WORK!

# Releases Note
Releases of this plugin consist of an empty string institution code by default.

# Apache Configuration

In order for the PALCI Redirect Plugin to work from the OPAC, Apache needs to be tweaked.

First, add the following line to your Apache configuration file:
`ScriptAlias /palci "/home/koha/koha-dev/var/lib/plugins/Koha/Plugin/Com/MarywoodUniversity/PALCIRedirect/palci-redirect.pl"`
where `/home/koha/koha-dev/var/lib/plugins/` is the path to your Koha installation's plugins folder.

# OPAC Javascript Link

Finally, create an access point on the OPAC (in this case, in the form of a link) that points to the `palci-redirect.pl` script.

The following code is added to Koha's OPACUserJS System Preference which will create an OPAC link in the header between Course Reserves and Recent Comments:

	/* Add PALCI link for redirection plugin script */
	$("moresearches ul li:nth-child(2)").append( " | <li><a id='palci-redirect' href='/palci'>PALCI</a></li>" );
	if ( ! $('.loggedinusername').length ) {
		$("#palci-redirect").addClass("loginModal-trigger");
	}

Once the OPAC link is created, being logged into Koha and clicking the PALCI link should now automatically authenticate patrons via NCIP.

**Apache Configuration and OPAC Javascript Link documentation provided by [Kyle M Hall](https://github.com/kylemhall).