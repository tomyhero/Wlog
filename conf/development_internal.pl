+{
    default => {
        'logger' => {
            'dispatchers' => [
                'screen'
                ],
                'screen' => {
                    'stderr' => '1',
                    'class' => 'Log::Dispatch::Screen',
                    'min_level' => 'debug',
                }
        },
    },
            'application' => {
                'web' => {
                    'plugins' => [
                        'Polocky::WAF::CatalystLike::Plugin::ShowDispatcher',
                        'Wlog::WAF::Plugin::FillInForm',
                        {
                            'Wlog::WAF::Plugin::FVL' => {
                                yaml_file => '__path_to(conf/dfv.yaml)__',
                            },          
                        },
                    ],
                    'middlewares' => [
                    {
                        'module' => 'Plack::Middleware::StackTrace'
                    },
                    {
                        'module' => 'Plack::Middleware::Static',
                        opts => {
                            path => qr{^/(image|js|css|static)/},
                            root => '__path_to(htdocs)__'
                        },
                    },
                    {
                        'module' => '+Wlog::WAF::Middleware::AuthBase',
                        opts => {
                            authenticator => sub {
                                my($username, $password) = @_;
                                return $username eq 'admin' && $password eq 'admin';
                            }
                        },
                    },
                    ]
                }
            }
}
