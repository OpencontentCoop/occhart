<div class="u-padding-all-s">
    <label class="Form-label">
        {'Query Parameters'|i18n('occhart/attribute')}
    </label>
    <div class="block">
        <div class="element" style="min-width: 300px">
            <input class="box"
                   name="{$attribute_base}_query_parameter_{$attribute.id}"
                   value="{if is_set($attribute_content.data_source_params.query_parameter)}{$attribute_content.data_source_params.query_parameter|wash()}{/if}"
                   type="text"/>
        </div>
        <div class="Grid-cell u-size4of12 u-sm-size4of12 u-md-size4of12 u-lg-size4of12">
            <input class="button" type="submit"
                   name="CustomActionButton[{$attribute.id}_ocql_query-save_query_parameter]"
                   value="{'Save'|i18n( 'design/standard/content/datatype' )}" />
        </div>
    </div>
</div>