package Koha::Plugin::Com::MarywoodUniversity::PALCIRedirect;

## It's good practice to use Modern::Perl
use Modern::Perl;

## Required for all plugins
use base qw( Koha::Plugins::Base );

## We will also need to include any Koha libraries we want to access
use C4::Auth;
use C4::Context;
use C4::Output;

## Here we set our plugin version
our $VERSION = 1.00;

## Here is our metadata. Some keys are required while some are optional.
our $metadata = {
    name            => 'PALCI Redirect',
    author          => 'Lee Jamison',
    description     => 'This plugin enables PALCI members to leverage Koha LDAP authentication to login to PALCI E-ZBorrow',
    date_authored   => '2016-07-22',
    date_updated    => '2016-07-22',
    minimum_version => '3.16',
    maximum_version => undef,
    version         => $VERSION,
};

## This is the minimum code required for a plugin's 'new' method.
## More can be added but none should be removed.
sub new {
    my ( $class, $args ) = @_;
    
    ## We need to add our metadata here so our base class can access it.
    $args->{'metadata'} = $metadata;
    $args->{'metadata'}->{'class'} = $class;
    
    ## Here, we call the 'new' method for our base class.
    ## This runs some additional magic and checking and
    ## returns our actual $self
    my $self = $class->SUPER::new( $args );
    
    return $self;
}

## The existance of a 'tool' subroutine means the plugin is capable
## of running a tool. The difference between a tool and a report is
## primarily semantic, but in general any plugin that modifies the
## Koha database should be considered a tool.
sub tool {
    my ( $self, $args ) = @_;
    
    my $cgi = $self->{'cgi'};
    
    my $template = $self->get_template( { file => 'palci-redirect-tool.tt' } );
    
    print $cgi->header();
    print $template->output();
}

## If your tool is complicated enough to needs it's own setting/configuration
## you will want to add a 'configure' method to your plugin like so.
## Here all the logic is thrown into the configure method.
sub configure {
    my ( $self, $args ) = @_;

    my $cgi = $self->{'cgi'};
    my $template = $self->get_template( { file => 'palci-redirect-configure.tt' } );
    my $op = $cgi->param('op') || q{};

    if ( $op eq '' ) { # displays currently configured values

        my $current_institutional_code = $self->retrieve_data('institutional_code');

        $template->param(
            op => $op,
            institutional_code => $current_institutional_code,
        );
    }
    elsif ( $op eq 'set-institutional-code') {

        my $new_institutional_code = $cgi->param('set-institutional-code') || q{};

        if ($new_institutional_code eq '') {

            $self->store_data({ institutional_code => "" }); # clears institutional_code value
        }
        else {

            $self->store_data({ institutional_code => $new_institutional_code });
        }

        my $current_institutional_code = $self->retrieve_data('institutional_code');

        $template->param(
            op => '',
            institutional_code => $current_institutional_code,
        );
    }
    
    print $cgi->header();
    print $template->output();
}

## This is the 'install' method. Any database tables or other setup that should
## be done when the plugin if first installed should be executed in this method.
## The installation method should always return true if the installation succeeded
## or false if it failed.
sub install() {
    my ( $self, $args ) = @_;
    
}

## This method will be run just before the plugin files are deleted
## when a plugin is uninstalled. It is good practice to clean up
## after ourselves!
sub uninstall() {
    my ( $self, $args ) = @_;
    
}

1;