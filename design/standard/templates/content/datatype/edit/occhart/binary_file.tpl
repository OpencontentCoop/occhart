{if is_set($attribute_content.data_source_params.original_filename)}
    {* Current file. *}
    <div class="u-padding-all-s">
        {'Selected file'|i18n('occhart/attribute')}:
        <input type="image"
               name="CustomActionButton[{$attribute.id}_binary_file-delete_binary]"
               style="vertical-align: middle"
               src={"trash.png"|ezimage} />
        <strong>{$attribute_content.data_source_params.original_filename|wash( xhtml )}</strong>
    </div>
{else}
    <input type="hidden" name="MAX_FILE_SIZE" value="80000000"/>
    <label>
        {'Select csv file'|i18n('occhart/attribute')}
    </label>
    <div class="block">
        <div class="element">
            <input class="Form-input"
                   name="{$attribute_base}_data_binaryfilename_{$attribute.id}" type="file"/>
        </div>
        <div class="element">
            <input class="button" type="submit" name="CustomActionButton[{$attribute.id}_binary_file-upload_binary]" value="{'Upload'|i18n( 'design/standard/content/datatype' )}" />
        </div>
    </div>
{/if}