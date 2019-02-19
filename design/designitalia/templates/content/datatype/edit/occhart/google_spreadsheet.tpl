<div class="u-padding-all-s">
{if is_set($attribute_content.data_source_params.spreadsheet_url)}
    <p>
        <button class="btn" type="submit"
                name="CustomActionButton[{$attribute.id}_google_spreadsheet-delete_url]"">
            <span class="fa fa-trash"></span>
        </button>
        <a href="{$attribute_content.data_source_params.spreadsheet_url|wash( xhtml )}">{$attribute_content.data_source_params.title|wash()}</a>
    </p>
    {if and( is_set($attribute_content.data_source_params.selected_sheet)|not(), $attribute_content.data_source_params.sheets|count()|gt(0))}
        <p>
            <label class="Form-label">
                {'Select sheet'|i18n('occhart/attribute')}
            </label>
            <div class="Grid Grid--withGutter">
                <div class="Grid-cell u-size6of12 u-sm-size6of12 u-md-size6of12 u-lg-size6of12">
                    <select class="Form-input"
                            id="{$attribute_base}_spreadsheet_sheet_{$attribute.id}"
                            name="{$attribute_base}_spreadsheet_sheet_{$attribute.id}">
                        {foreach $attribute_content.data_source_params.sheets as $sheet}
                            <option value="{$sheet|wash()}">{$sheet|wash()}</option>
                        {/foreach}
                    </select>
                </div>
                <div class="Grid-cell u-size6of12 u-sm-size6of12 u-md-size6of12 u-lg-size6of12" style="padding-top: 7px">
                    <input id="{$attribute_base}_google_spreadsheet_select_sheet_{$attribute.id}_select_button"
                           class="button defaultbutton"
                           type="submit"
                           name="CustomActionButton[{$attribute.id}_google_spreadsheet-select_sheet]"
                           value="{'Select'|i18n( 'design/standard/content/datatype' )}" />
                </div>
            </div>
        </p>
    {else}
        <p>
            <button class="btn" type="submit"
                    name="CustomActionButton[{$attribute.id}_google_spreadsheet-delete_sheet]">
                <span class="fa fa-trash"></span>
            </button>
            {'Selected sheet'|i18n( 'design/standard/content/datatype' )}: {$attribute_content.data_source_params.selected_sheet}
        </p>
    {/if}
{else}
    <em class="attribute-description">
        {'Share your google spreadsheet as "Public" or "Anyone with link" using Share button and publish it to the web (via "File/Publish to the web..." menu)'|i18n( 'design/standard/content/datatype' )}
    </em>
    <label class="Form-label">
        {'Select Url'|i18n('occhart/attribute')}
    </label>
    <div class="Grid Grid--withGutter">
        <div class="Grid-cell u-size6of12 u-sm-size6of12 u-md-size6of12 u-lg-size6of12">
            <input class="Form-input"
                   name="{$attribute_base}_spreadsheet_url_{$attribute.id}" type="text"/>
        </div>
        <div class="Grid-cell u-size6of12 u-sm-size6of12 u-md-size6of12 u-lg-size6of12" style="padding-top: 2px">
            <button class="btn" type="submit"
                    name="CustomActionButton[{$attribute.id}_google_spreadsheet-select_url]">
                {'Select'|i18n( 'design/standard/content/datatype' )}
            </button>
        </div>
    </div>
{/if}
</div>