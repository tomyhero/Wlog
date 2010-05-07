<div class="information-box">
    <ul class="information-category">
        <li class="title">カテゴリ:</li>
        <li class="parent"><a href="/[% article_obj.category_obj.key %]/">[% article_obj.category_obj.name | html %]</a></li>
    </ul>
    <ul class="information-tags">
        <li class="title">タグ:</li>
        <li class="parent">       
    [% FOREACH obj IN article_obj.tag_objs %]
        <a href="/tag/[% obj.name | uri %]/">[% obj.name | html %]</a>&nbsp;
    [% END %]
        </li>
    </ul>
    <ul class="information-page_edit">
        <li class="title"><a href="/cms/category/[% article_obj.category_obj.id %]/article/[% article_obj.id %]/edit/">記事編集</a></li>
    </ul>
</div>

