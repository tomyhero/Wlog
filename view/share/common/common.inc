[%- FILTER null -%]

[%- MACRO paging(pager) BLOCK %]
[% IF pager.last_page != pager.first_page %]
<div class="pager">
[%- IF pager.previous_page %]<a href="[% pager.build_uri(pager.previous_page) %]" class="prev">前</a> [% END %]
[%- FOR p = pager.pages_in_navigation(10) %]
[%- IF p == pager.current_page %]<span>[% p %]</span> [% ELSE %]<a href="[% pager.build_uri(p) %]" class="number">[% p %]</a> [% END -%]
[%- END %]
[%- IF pager.next_page %] <a href="[% pager.build_uri(pager.next_page) %]" class="next">次</a>[% END %]
</div><!-- /pager -->
[% END # over 1 page %]
[%- END # END MACRO %]

[%- END #FILTER null -%]
