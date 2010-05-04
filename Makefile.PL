use inc::Module::Install;
name 'Wlog';
all_from 'lib/Wlog.pm';

# requires '';

tests 't/*.t';
author_tests 'xt';

test_requires 'Test::More';
test_requires 'Test::LoadAllModules';
auto_include;
WriteAll;
