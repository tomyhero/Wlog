<html>
<head>
<link rel="stylesheet" href="/css/core.css" type="text/css" />
<link rel="stylesheet" href="/static/wiki/css/cpan-like.css" type="text/css" media="all" />
<title>Hi</title>
</head>
<body>
<div id="wrap">
<div id="container">
<div id="header">
<h1>Lazy Programmer's Wlog[% IF category_obj %] / [% category_obj.name | html %] [% END %]</h1>
<ul id="navi">
    <li><a href="/">Blog</a></li>
    [% FOR obj IN category_objs %]
    <li><a href="/[% obj.key %]/">[% obj.name | html %]</a></li>
    [% END %]
</ul>
<div class="fixed"></div>
</div>
<div id="content">
