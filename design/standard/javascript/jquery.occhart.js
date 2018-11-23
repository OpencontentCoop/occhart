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
            new Highcharts.Chart(options);
        });

        return this;
    };
 
}( jQuery ));