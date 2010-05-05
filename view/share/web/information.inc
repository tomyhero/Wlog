<div class="information-box">
    <ul id="information-category">
        <li class="title">カテゴリ:</li>
        <li class="parent"><a href="/[% article_obj.category_obj.key %]/">[% article_obj.category_obj.name | html %]</a></li>
    </ul>
    <ul id="information-tags">
        <li class="title">タグ:</li>
        <li class="parent">       
    [% FOREACH obj IN article_obj.tag_objs %]
        <a href="/tag/[% obj.name | uri %]/">[% obj.name | html %]</a>&nbsp;
    [% END %]
        </li>
    </ul>
</div>
