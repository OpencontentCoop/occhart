<?php

/** @var eZModule $module */
$module = $Params['Module'];
$attributeId = $Params['AttributeId'];
$version = $Params['AttributeVersion'];

ob_get_clean();
if (!isset($_GET['debug'])) {
    header('Content-Type: text/plain; charset=utf-8');
}
$contentObjectAttribute = eZContentObjectAttribute::fetch((int)$attributeId, (int)$version);
if ($contentObjectAttribute instanceof eZContentObjectAttribute && $contentObjectAttribute->attribute('data_type_string') == OCChartType::DATA_TYPE_STRING){
    if ($contentObjectAttribute->object()->canRead()) {
        $content = $contentObjectAttribute->content();
        if ($content['data_source'] && OCChartDataSourceHandler::exists($content['data_source'])) {
            OCChartDataSourceHandler::get($content['data_source'])->downloadCsvData($contentObjectAttribute, $version, $content);
        }
    }
}
eZExecution::cleanExit();




/*
$list = array(
    array('', 'aaa', 'bbb', 'ccc', 'dddd'),
    array('uno', 123, 456, 789, 123),
    array('due', 321, 543, 654, 123),
    array('tre', 321, 543, 654, 123)
);

$output = fopen('php://output', 'w');

foreach ($list as $fields) {
    fputcsv($output, $fields);
    flush();
}
*/

