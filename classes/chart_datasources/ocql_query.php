<?php

class OCChartDataSourceOcqlQuery  implements OCChartDataSourceInterface
{
    public function getIdentifier()
    {
        return "ocql_query";
    }

    public function getName()
    {
        return "Opendata API Query";
    }

    public function downloadCsvData($contentObjectAttribute, $version, $content)
    {
        if (isset($content['data_source_params']['query_parameter'])) {
            $parser = new OCChartOcqlQueryParser($content['data_source_params']['query_parameter']);
            $parser->getData();
        }

        eZExecution::cleanExit();
    }

    public function hasEditTemplate()
    {
        return true;
    }

    public function initialize($contentObjectAttribute, $currentVersion, $originalContentObjectAttribute, &$content)
    {

    }

    /**
     * @param eZContentObjectAttribute $contentObjectAttribute
     * @param array $content
     * @return void
     */
    public function remove($contentObjectAttribute, &$content)
    {
        $content['data_source_params'] = array();
        $content['data_source_is_valid'] = false;
    }

    public function action($http, $action, $contentObjectAttribute, $parameters)
    {
        switch ($action) {
            case 'save_query_parameter' :
                {
                    $postQueryName = 'ContentObjectAttribute' . "_query_parameter_" . $contentObjectAttribute->attribute("id");
                    if($http->hasPostVariable($postQueryName)) {
                        $query = $http->postVariable($postQueryName);
                        $content = $contentObjectAttribute->content();
                        $content['data_source_params'] = array(
                            'query_parameter' => $query
                        );
                        $content['data_source_is_valid'] = true;
                        $contentObjectAttribute->setContent($content);
                        $contentObjectAttribute->store();
                    }
                }
                break;

            default :
                {
                    eZDebug::writeError('Unknown custom HTTP action: ' . $action, __METHOD__);
                }
                break;
        }
    }

    /**
     * @param eZContentObjectAttribute $contentObjectAttribute
     * @param null|int $version
     * @param array $content
     * @return void
     */
    public function delete($contentObjectAttribute, $version,  &$content)
    {

    }

}