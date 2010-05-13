+{
    database => {
        'connect_options' => {
            'mysql_enable_utf8' => '1'
        },
            'password' => undef,
            'dsn' => 'dbi:mysql:wlog_dev',
            'username' => 'root'
    },
    site => {
        'css_core_url' => '/css/core.css',
        'css_cms_url'  => '/css/cms.css',
        'css_wiki_url' => '/static/wiki/css/cpan-like.css',
        'title' => "Lazy Programmer's Wlog",
        'copyright' => "Copyright &copy; lazy-programmer.com All Rights Reserved.",
    },
    'auth' => {
        'htpasswd_file' => "__path_to(conf/.htpasswd)__",
    },
    'resource' => {
        'footer_freearea_path' => "__path_to(resource/footer_freearea.html)__",
    }
}
