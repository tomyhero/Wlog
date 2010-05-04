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
            'middlewares' => [
            {
                'module' => 'Plack::Middleware::Static',
                opts => {
                    path => qr{^/(image|js|css|static)/},
                    root => '__path_to(htdocs)__'
                },
            },

            ]
        }
    }
}
