+{
    database => {
        'connect_options' => {
            'mysql_enable_utf8' => '1'
        },
            'password' => undef,
            'dsn' => 'dbi:mysql:wlog',
            'username' => 'root'
    },
    site => {
        'css_core_url' => '/css/core.css',
        'css_cms_url'  => '/css/cms.css',
        'css_wiki_url' => '/static/wiki/css/cpan-like.css',
        'title' => "Lazy Programmer's Wlog",
        'copyright' => "Copyright &copy; lazy-programmer.com All Rights Reserved.",
    }
}
