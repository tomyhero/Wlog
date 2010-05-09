<table class="form">
[% FOREACH field IN sidebar_plugin.fields %]
<tr>
    <th>[% sidebar_plugin.labels.${field.name} %]</td>
    [% IF field.type == 'textarea' %]
    <td><textarea name="[% field.name %]" cols="100" rows="5"></textarea></td>
    [% ELSE %]
    <td><input type="text" name="[% field.name %]" size="50" /></td>
    [% END %]
</tr>
[% END %]
<tr>
    <th>順番</th>
    <td><input type="text" name="sort" value="1" /></td>
</tr>
<tr>
    <td colspan="2"><input type="submit" value="追加" /></td>
</tr>
</table>
