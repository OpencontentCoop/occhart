<div class="u-padding-all-s">
    <label class="Form-label">
        {'Query Parameters'|i18n('occhart/attribute')}
    </label>
    <div class="Grid Grid--withGutter">
        <div class="Grid-cell u-size8of12 u-sm-size8of12 u-md-size8of12 u-lg-size8of12">
            <input class="Form-input"
                   name="{$attribute_base}_query_parameter_{$attribute.id}"
                   value="{if is_set($attribute_content.data_source_params.query_parameter)}{$attribute_content.data_source_params.query_parameter|wash()}{/if}"
                   type="text"/>
        </div>
        <div class="Grid-cell u-size4of12 u-sm-size4of12 u-md-size4of12 u-lg-size4of12" style="padding-top: 2px">
            <button class="btn" type="submit"
                    name="CustomActionButton[{$attribute.id}_ocql_query-save_query_parameter]">
                {'Save'|i18n( 'design/standard/content/datatype' )}
            </button>
        </div>
    </div>
</div>