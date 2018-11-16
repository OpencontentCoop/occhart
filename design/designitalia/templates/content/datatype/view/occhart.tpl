{def $attribute_content = $attribute.content}

{if $attribute_content.data_source_is_valid}
    <div id="chart-render_{$attribute.id}">
        <p class="text-center"><i class="fa fa-spinner fa-spin fa-3x fa-fw"></i></p>
    </div>

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

    <script>{literal}
        $(document).ready(function(){
            var easyChart_{/literal}{$attribute.id}{literal} = new ec({
                dataUrl: "{/literal}{concat('/occhart/data/', $attribute.id, '/', $attribute.version)|ezurl(no)}{literal}"
            });
            easyChart_{/literal}{$attribute.id}{literal}.setConfigStringified({/literal}'{$attribute_content.config_string|wash(javascript)}'{literal});
            easyChart_{/literal}{$attribute.id}{literal}.on('dataUpdate', function(e){
                var options = easyChart_{/literal}{$attribute.id}{literal}.getConfigAndData();
                options.chart.renderTo = $('#chart-render_{/literal}{$attribute.id}{literal}')[0];
                var chart_{/literal}{$attribute.id}{literal} = new Highcharts.Chart(options);
            });
        });
    {/literal}</script>
{/if}
{undef $attribute_content}