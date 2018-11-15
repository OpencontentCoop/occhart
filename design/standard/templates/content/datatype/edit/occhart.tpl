{default attribute_base='ContentObjectAttribute' html_class='full' placeholder=false()}
{def $attribute_content = $attribute.content}
    {$attribute_content|attribute(show,4)}
<filedset class="Form-field{if $attribute.has_validation_error} has-error{/if}">

    {run-once}
        <script type="text/javascript" src="//code.highcharts.com/highcharts.js" charset="utf-8"></script>
        <script type="text/javascript" src="//code.highcharts.com/highcharts-3d.js" charset="utf-8"></script>
        <script type="text/javascript" src="//code.highcharts.com/highcharts-more.js" charset="utf-8"></script>
        <script type="text/javascript" src="//code.highcharts.com/modules/funnel.js" charset="utf-8"></script>
        <script type="text/javascript" src="//code.highcharts.com/modules/heatmap.js" charset="utf-8"></script>
        <script type="text/javascript" src="//code.highcharts.com/modules/solid-gauge.js" charset="utf-8"></script>
        <script type="text/javascript" src="//code.highcharts.com/modules/treemap.js" charset="utf-8"></script>
        <script type="text/javascript" src="//code.highcharts.com/modules/boost.js" charset="utf-8"></script>
        <script type="text/javascript" src="//code.highcharts.com/modules/exporting.js"></script>
        <script type="text/javascript" src="//code.highcharts.com/modules/no-data-to-display.js"></script>
    {ezscript_require(array('ezjsc::jquery','ec.min.js'))}
    {ezcss_require(array('ec.css'))}
    {/run-once}

    <legend class="Form-label {if $attribute.is_required}is-required{/if}">
        {first_set( $contentclass_attribute.nameList[$content_language], $contentclass_attribute.name )|wash}
        {if $attribute.is_information_collector} <em class="collector">{'information collector'|i18n( 'design/admin/content/edit_attribute' )}</em>{/if}
        {if $attribute.is_required} ({'richiesto'|i18n('design/ocbootstrap/designitalia')}){/if}
    </legend>

    {if $contentclass_attribute.description}
        <em class="attribute-description">{first_set( $contentclass_attribute.descriptionList[$content_language], $contentclass_attribute.description)|wash}</em>
    {/if}

    <div class="clearfix">


        {if $attribute_content.data_source|not()}
            <label class="Form-label {if $attribute.is_required}is-required{/if}" for="{$attribute_base}_occhart_select_source_{$attribute.id}">
                {'Select data source'|i18n('occhart/attribute')}
            </label>
            <div class="Grid Grid--withGutter">
                <div class="Grid-cell u-size6of12 u-sm-size6of12 u-md-size6of12 u-lg-size6of12">
                    <select class="Form-input"
                            id="{$attribute_base}_occhart_select_source_{$attribute.id}"
                            name="{$attribute_base}_occhart_select_source_{$attribute.id}">
                        <option></option>
                        {foreach $attribute_content.source_type_list as $identifier => $name}
                            <option value="{$identifier|wash()}">{$name|wash()}</option>
                        {/foreach}
                    </select>
                </div>
                <div class="Grid-cell u-size6of12 u-sm-size6of12 u-md-size6of12 u-lg-size6of12" style="padding-top: 7px">
                    <input id="{$attribute_base}_occhart_select_source_{$attribute.id}_select_button"
                           class="button defaultbutton"
                           type="submit"
                           name="CustomActionButton[{$attribute.id}_select_source]"
                           value="{'Select'|i18n( 'design/standard/content/datatype' )}" />
                </div>
            </div>

        {else}
            <p>
                <strong>
                    {'Selected data source'|i18n('occhart/attribute')}: {$attribute_content.source_type_list[$attribute_content.data_source]}
                </strong>

                <input id="{$attribute_base}_occhart_remove_source_{$attribute.id}"
                       class="Button Button--danger pull-right"
                       type="submit"
                       name="CustomActionButton[{$attribute.id}_remove_source]"
                       value="{'Remove'|i18n( 'design/standard/content/datatype' )}" />
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
</filedset>
{undef $attribute_content}
{/default}
