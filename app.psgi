use strict;
use warnings;
use utf8;
use File::Spec;
use File::Basename;
use lib File::Spec->catdir(dirname(__FILE__), 'extlib', 'lib', 'perl5');
use lib File::Spec->catdir(dirname(__FILE__), 'lib');
use Amon2::Lite;

our $VERSION = '0.01';

# put your configuration here
sub load_config {
    my $c = shift;

    my $mode = $c->mode_name || 'development';

    +{
        'DBI' => [
            'dbi:SQLite:dbname=$mode.db',
            '',
            '',
        ],
    }
}

get '/' => sub {
    my $c = shift;
    return $c->render('index.tt');
};

# load plugins
__PACKAGE__->load_plugin('Web::CSRFDefender');
# __PACKAGE__->load_plugin('DBI');
# __PACKAGE__->load_plugin('Web::FillInFormLite');
__PACKAGE__->load_plugin('Web::JSON');

__PACKAGE__->enable_session();

__PACKAGE__->to_app(handle_static => 1);

__DATA__

@@ index.tt
<!doctype html>
<html>
<head>
    <meta charset="utf-8">
    <title>NINA'S Selection</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script type="text/javascript" src="[% uri_for('/static/js/jquery-1.9.1.min.js') %]"></script>
    <script type="text/javascript" src="[% uri_for('/static/js/main.js') %]"></script>
    <script type="text/javascript" src="[% uri_for('/static/js/jquery.masonry.min.js') %]"></script>
    <link rel="stylesheet" href="[% uri_for('/static/css/main.css') %]">
    <style>
        .item {
          width: 220px;
          margin: 5px;
          float: left;
          border: 1px solid #ccc;
          background: #eee;
          box-shadow: 0 2px 1px #eee;
          overflow:hidden;
        }
        img {
            vertical-align: bottom;
        }
#container {
padding: 10px;
background-color: #ccc;
}

    </style>
    <script type="text/javascript">
        $(document).ready(function() {
            var html = "";
            for (var i = 0; i < 10; i++) {
                html += "<div class='item'><img src='http://biography.sophia-it.com/imgb/binmi001.png'></div>";
            }
            $('#container').html(html);

            $('#container').imagesLoaded(function() {
                $('#container').masonry({
                itemSelector : '.item',
                isAnimated: true
                });
            });
        });
    </script>
</head>
<body>
    <div class="container">
        <header><h1>NINA'S Selection!</h1></header>
        <div id="container"></div>
        <footer>Powered by <a href="http://amon.64p.org/">Amon2::Lite</a></footer>
    </div>
</body>
</html>

@@ /static/js/main.js

@@ /static/css/main.css
footer {
    text-align: right;
}
