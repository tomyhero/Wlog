+{
    default => {
        'logger' => {
            'dispatchers' => [
                'screen'
                ],
                'screen' => {
                    'stderr' => '1',
                    'class' => 'Log::Dispatch::Screen',
                    'min_level' => 'debug'
                }
        },
    },
            'application' => {
                'web' => {
                    'plugins' => [
                        'Polocky::WAF::CatalystLike::Plugin::ShowDispatcher',
                    ],
                    'middlewares' => [
                    {
                        'module' => 'Plack::Middleware::Static',
                        opts => {
                            path => qr{^/(image|js|css|static)/},
                            root => '__path_to(htdocs)__'
                        },
                    },
                    {
                        'module' => 'Plack::Middleware::StackTrace'
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
