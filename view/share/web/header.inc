<html>
<head>
<link rel="stylesheet" href="[% config.site('css_core_url') %]" type="text/css" />
<link rel="stylesheet" href="[% config.site('css_cms_url') %]" type="text/css" />
<link rel="stylesheet" href="[% config.site('css_wiki_url') %]" type="text/css" media="all" />
<link rel="alternate" type="application/rss+xml" title="RSS 1.0" href="/feed/" />
<script type="text/javascript" src="/js/wlog.util.js"></script>
<script type="text/javascript" src="/js/prettify.js"></script>
<link rel="stylesheet" href="/css/prettify.css" type="text/css" media="all" />

[% IF mode == 'cms' %]
<script type="text/javascript" src="/js/jquery-1.4.2.min.js"></script>
<script type="text/javascript" src="/js/wlog.api.js"></script>
<title>[% config.site('title') %] CMS</title>
[% ELSE %]
<title>[% config.site('title') %][% IF category_obj.id %] / [% category_obj.name | html %] [% END %][% IF article_obj %]/[% article_obj.name | html %] [% END %][% IF tag_obj %] Tag:[% tag_obj.name | html %][% END %]</title>
[% END %]
</head>
<body onload="prettyPrint()">
<div id="wrap">
<div id="container">
<div id="header">
<h1><a href="/">[% config.site('title') %][% IF category_obj.id %] / [% category_obj.name | html %] [% END %]</a></h1>
<ul id="navi">
    <li><a href="/">Blog</a></li>
[% IF mode == 'cms' %]
    <li><a href="/cms/category/">カテゴリ設定</a></li>
    <li><a href="/cms/category/0/sidebar/">デフォルトサイドメニュー設定</a></li>
[% ELSE %]
    [% FOR obj IN category_objs %]
    <li><a href="/[% obj.key %]/">[% obj.name | html %]</a></li>
    [% END %]
[% END %]
</ul>
<div class="fixed"></div>
</div>
<div id="content">
