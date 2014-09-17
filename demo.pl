#!/usr/bin/env perl
BEGIN { $ENV{MOJO_MODE} ||= 'production' }
use Mojolicious::Lite;
plugin 'JQuery', migrate => 1;

get '/' => 'index';
app->start;

__DATA__
@@ index.html.ep
  <!doctype html>
  <html>
    <head>
    	<meta charset="utf-8">
  	<title>class demo</title>
  	<style>
  		div, span {
    			width: 120px;
    			height: 40px;
    			float: left;
    			padding: 10px;
    			margin: 10px;
    			background-color: #EEEEEE;
		  }
  	</style>
      	%= asset "jquery.js"
    </head>
    <body>
      	<div class="notMe">div class="notMe"</div>
	<div class="myClass">div class="myClass"</div>
	<span class="myClass">span class="myClass"</span>
	<script>
		$( ".myClass" ).css( "border", "3px solid red" );
	</script>
    </body>
  </html>
