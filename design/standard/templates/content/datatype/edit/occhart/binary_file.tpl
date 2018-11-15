{if is_set($attribute_content.data_source_params.original_filename)}
    {* Current file. *}
    <div class="u-padding-all-s">
        <button class="btn" type="submit"
                name="CustomActionButton[{$attribute.id}_binary_file-delete_binary]"
                title="{'Remove the file from this draft.'|i18n( 'design/standard/content/datatype' )}">
            <span class="fa fa-trash"></span>
        </button>
        {$attribute_content.data_source_params.original_filename|wash( xhtml )}
    </div>
{else}
    <input type="hidden" name="MAX_FILE_SIZE" value="80000000"/>
    <div class="Grid Grid--withGutter">
        <div class="Grid-cell u-size6of12 u-sm-size6of12 u-md-size6of12 u-lg-size6of12">
            <input class="Form-input"
                   name="{$attribute_base}_data_binaryfilename_{$attribute.id}" type="file"/>
        </div>
        <div class="Grid-cell u-size6of12 u-sm-size6of12 u-md-size6of12 u-lg-size6of12" style="padding-top: 7px">
            <button class="btn" type="submit"
                    name="CustomActionButton[{$attribute.id}_binary_file-upload_binary]">
                {'Upload'|i18n( 'design/standard/content/datatype' )}
            </button>
        </div>
    </div>
{/if}