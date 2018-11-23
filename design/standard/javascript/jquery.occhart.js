(function ( $ ) {
 
    $.fn.occhart = function() {
        var $element = $(this);
        var settings = $element.data();
 
        var easyChart = new ec({
            dataUrl: settings.url
        });
        easyChart.setConfigStringified(JSON.stringify(settings.config));
        easyChart.on('dataUpdate', function(e){
            var options = easyChart.getConfigAndData();
            options.chart.renderTo = $element[0];
            if (typeof settings.ratio == 'string'){
                var ratioParts = settings.ratio.split(':');
                options.chart.height = (ratioParts[1]/ratioParts[0] * 100) + '%';
            }
            if(settings.hidelegend){
                options.legend = {enabled: false};
            }
            if(settings.hidetitle){
                options.title = {text: null};
                options.subtitle = {text: null};                    
            }
            if(settings.hideexport){
                options.exporting = {enabled: false};
            }
            new Highcharts.Chart(options);
        });

        return this;
    };
 
}( jQuery ));