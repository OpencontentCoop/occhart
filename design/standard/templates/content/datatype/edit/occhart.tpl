{default attribute_base='ContentObjectAttribute' html_class='full' placeholder=false()}
{def $attribute_content = $attribute.content}

<fieldset class="Form-field{if $attribute.has_validation_error} has-error{/if}">

    {run-once}
    {ezscript_require(array(
        'ezjsc::jquery',
        'ec.min.js',
        'highcharts/highcharts.js',
        'highcharts/highcharts-3d.js',
        'highcharts/highcharts-more.js',
        'highcharts/modules/funnel.js',
        'highcharts/modules/heatmap.js',
        'highcharts/modules/solid-gauge.js',
        'highcharts/modules/treemap.js',
        'highcharts/modules/boost.js',
        'highcharts/modules/exporting.js',
        'highcharts/modules/no-data-to-display.js'
    ))}
    {ezcss_require(array(
        'ec.css',
        'highcharts/highcharts.css'
    ))}
    {/run-once}

    <div class="clearfix">
        {if $attribute_content.data_source|not()}
            <label class="{if $attribute.is_required}is-required{/if}" for="{$attribute_base}_occhart_select_source_{$attribute.id}">
                {'Select data source'|i18n('occhart/attribute')}
            </label>
            <div class="block">
                <div class="element">
                    <select class="halfbox"
                            id="{$attribute_base}_occhart_select_source_{$attribute.id}"
                            name="{$attribute_base}_occhart_select_source_{$attribute.id}">
                        <option></option>
                        {foreach $attribute_content.source_type_list as $identifier => $name}
                            <option value="{$identifier|wash()}">{$name|wash()}</option>
                        {/foreach}
                    </select>
                </div>
                <div class="element">
                    <input id="{$attribute_base}_occhart_select_source_{$attribute.id}_select_button"
                           class="button"
                           type="submit"
                           name="CustomActionButton[{$attribute.id}_select_source]"
                           value="{'Select'|i18n( 'design/standard/content/datatype' )}" />
                </div>
            </div>
        {else}
            <p>
                {'Selected data source'|i18n('occhart/attribute')}:
                <input id="{$attribute_base}_occhart_remove_source_{$attribute.id}"
                       type="image"
                       style="vertical-align: middle"
                       name="CustomActionButton[{$attribute.id}_remove_source]"
                       value="{'Remove'|i18n( 'design/standard/content/datatype' )}"
                       src={"trash.png"|ezimage} />
                <strong>{$attribute_content.source_type_list[$attribute_content.data_source]}</strong>
            </p>

            {if $attribute_content.data_source_edit_template}
                {include uri=concat("design:content/datatype/edit/occhart/", $attribute_content.data_source, ".tpl")}
            {/if}

            {if $attribute_content.data_source_is_valid}
                <input id="{$attribute_base}_occhart_config_{$attribute.id}"
                       class="chart-data"
                       type="hidden"
                       name="{$attribute_base}_occhart_config_{$attribute.id}"
                       value="{$attribute_content.config_string|wash()}" />

                <div id="ochart-{$attribute.id}" class="chart-editor" style="margin: 20px 0"></div>

                <script>{literal}
                    $(document).ready(function(){
                        var easyChart_{/literal}{$attribute.id}{literal} = new ec({
                            debuggerTab: {/literal}{cond(ezini("DebugSettings", "DebugOutput")|eq('enabled'), 'true', 'false')}{literal},
                            chartTab: true,
                            dataTab: {/literal}{cond(ezini("DebugSettings", "DebugOutput")|eq('enabled'), 'true', 'false')}{literal},
                            showLogo: false,
                            element: $('#ochart-{/literal}{$attribute.id}{literal}')[0],
                            dataUrl: "{/literal}{concat('/occhart/data/', $attribute.id, '/', $attribute.version)|ezurl(no)}{literal}"
                        });
                        if ($('#{/literal}{$attribute_base}_occhart_config_{$attribute.id}{literal}').val()){
                            easyChart_{/literal}{$attribute.id}{literal}.setConfigStringified($('#{/literal}{$attribute_base}_occhart_config_{$attribute.id}{literal}').val());
                        }
                        easyChart_{/literal}{$attribute.id}{literal}.on('configUpdate', function(e){
                            $('#{/literal}{$attribute_base}_occhart_config_{$attribute.id}{literal}').val(easyChart_{/literal}{$attribute.id}{literal}.getConfigStringified());
                        });
                    });
                {/literal}</script>
            {/if}
        {/if}
    </div>
</fieldset>
{undef $attribute_content}
{/default}