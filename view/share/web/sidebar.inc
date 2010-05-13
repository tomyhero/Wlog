[% IF on_sidebar %]
<div id="sidebar">
[% FOREACH sidebar_obj IN category_obj.sidebar_objs %]
[% plugin_obj = sidebar_obj.plugin_obj( category_obj ) %]
<div class="side-box">
<div class="box-inner">
<div class="title"><h2>[% plugin_obj.name_field | html %]</h2></div>
<div class="body">
<div class="inner">
[% plugin_obj.disp_html %]
</div><!-- /inner -->
</div><!-- /.body -->
</div><!-- /.box-inner -->
</div><!-- /side-box -->
[% END %]
</div>
[% END %]
