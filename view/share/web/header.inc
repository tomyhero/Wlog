<html>
<head>
<link rel="stylesheet" href="/css/core.css" type="text/css" />
<link rel="stylesheet" href="/css/cms.css" type="text/css" />
<link rel="stylesheet" href="/static/wiki/css/cpan-like.css" type="text/css" media="all" />
<title>Lazy Programmer's Wlog[% IF category_obj %] / [% category_obj.name | html %] [% END %]</title>
</head>
<body>
<div id="wrap">
<div id="container">
<div id="header">
<h1>Lazy Programmer's Wlog[% IF category_obj %] / [% category_obj.name | html %] [% END %]</h1>
<ul id="navi">
    <li><a href="/">Blog</a></li>
[% IF mode == 'cms' %]
    <li><a href="/cms/sidebar/">サイドメニュー管理</a></li>
[% ELSE %]
    [% FOR obj IN category_objs %]
    <li><a href="/[% obj.key %]/">[% obj.name | html %]</a></li>
    [% END %]
[% END %]
</ul>
<div class="fixed"></div>
</div>
<div id="content">
