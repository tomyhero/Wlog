[% IF form.has_error %]
<div id="fvl">
<ul>
[% FOREACH e IN form.error_message %]
    <li>[% e.value %]</li>
[% END %]
</ul>
</div>
[% END %]
