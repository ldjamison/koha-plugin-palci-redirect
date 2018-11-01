#!/usr/bin/perl
#
# Copyright 2016 Marywood University
#
# This file is not part of Koha.
#
# Koha is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.
#
# Koha is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Koha; if not, see <http://www.gnu.org/licenses>.

use Modern::Perl;

use C4::Context;
use C4::Output;
use C4::Auth;

use CGI qw ( -utf8 );

my $cgi = new CGI;

my ( $template, $borrowernumber, $cookie ) = get_template_and_user(
	{
		template_name	=> "palci-redirect.tt",
		query			=> $cgi,
		type			=> "opac",
		authnotrequired	=> 0,
		debug			=> 1,
	}
);

## Relais institution code
my $institutionCode = "";

## Base URL for E-ZBorrow NCIP Authentication
my $baseURL = "https://ezb.relaisd2d.com/?LS=$institutionCode&PI=";

## Currently logged in user's card number (barcode)
my $cardNumber = C4::Context->userenv->{'cardnumber'};

## Redirect the page to E-ZBorrow with current user's card number appended to the end of URL
print $cgi->redirect( $baseURL . $cardNumber );