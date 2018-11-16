<div class="u-padding-all-s">
{if is_set($attribute_content.data_source_params.spreadsheet_url)}
    <p>
        {'Selected spreadsheet'|i18n('occhart/attribute')}:
        <input type="image"
               name="CustomActionButton[{$attribute.id}_google_spreadsheet-delete_url]"
               style="vertical-align: middle"
               src={"trash.png"|ezimage} />
        <a href="{$attribute_content.data_source_params.spreadsheet_url|wash( xhtml )}">{$attribute_content.data_source_params.title|wash()}</a>
    </p>
    {if and( is_set($attribute_content.data_source_params.selected_sheet)|not(), $attribute_content.data_source_params.sheets|count()|gt(1))}
        <label class="Form-label">
            {'Select sheet'|i18n('occhart/attribute')}
        </label>
        <div class="block">
            <div class="element">
                <select class="box"
                        id="{$attribute_base}_spreadsheet_sheet_{$attribute.id}"
                        name="{$attribute_base}_spreadsheet_sheet_{$attribute.id}">
                    {foreach $attribute_content.data_source_params.sheets as $sheet}
                        <option value="{$sheet|wash()}">{$sheet|wash()}</option>
                    {/foreach}
                </select>
            </div>
            <div class="element">
                <input id="{$attribute_base}_google_spreadsheet_select_sheet_{$attribute.id}_select_button"
                       class="button"
                       type="submit"
                       name="CustomActionButton[{$attribute.id}_google_spreadsheet-select_sheet]"
                       value="{'Select'|i18n( 'design/standard/content/datatype' )}" />
            </div>
        </div>
    {else}
        <p>
            {'Selected sheet'|i18n( 'design/standard/content/datatype' )}:
            <input type="image"
                   name="CustomActionButton[{$attribute.id}_google_spreadsheet-delete_sheet]"
                   style="vertical-align: middle"
                   src={"trash.png"|ezimage} />
            {$attribute_content.data_source_params.selected_sheet}
        </p>
    {/if}
{else}
    <p>
        <em class="attribute-description">
            {'Share your google spreadsheet as "Public" or "Anyone with link" using Share button and publish it to the web (via "File/Publish to the web..." menu)'|i18n( 'design/standard/content/datatype' )}
        </em>
    </p>
    <label class="Form-label">
        {'Input Public Google Spreadsheet Share url'|i18n('occhart/attribute')}
    </label>
    <div class="block">
        <div class="element">
            <input class="box"
                   name="{$attribute_base}_spreadsheet_url_{$attribute.id}" type="text"/>
        </div>
        <div class="element">
            <input class="button" type="submit"
                    name="CustomActionButton[{$attribute.id}_google_spreadsheet-select_url]"
                    value="{'Select'|i18n( 'design/standard/content/datatype' )}" />
        </div>
    </div>
{/if}
</div>