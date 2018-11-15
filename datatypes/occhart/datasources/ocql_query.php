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
        // TODO: Implement downloadCsvData() method.
    }

    public function hasEditTemplate()
    {
        // TODO: Implement hasEditTemplate() method.
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

    }

    public function action($http, $action, $contentObjectAttribute, $parameters)
    {

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