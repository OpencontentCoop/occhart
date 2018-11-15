{def $attribute_content = $attribute.content}

{if $attribute_content.data_source_is_valid}
    <div id="chart-render_{$attribute.id}">
        <p class="text-center"><i class="fa fa-spinner fa-spin fa-3x fa-fw"></i></p>
    </div>

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