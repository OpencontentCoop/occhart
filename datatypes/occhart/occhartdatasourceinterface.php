<?php

interface OCChartDataSourceInterface
{
    /**
     * @return string
     */
    public function getIdentifier();

    /**
     * @return string
     */
    public function getName();

    /**
     * @param eZContentObjectAttribute $contentObjectAttribute
     * @param int $version
     * @param array $content
     * @return mixed
     */
    public function downloadCsvData($contentObjectAttribute, $version, $content);

    /**
     * @return bool
     */
    public function hasEditTemplate();

    /**
     * @param eZContentObjectAttribute $contentObjectAttribute
     * @param int $currentVersion
     * @param eZContentObjectAttribute $originalContentObjectAttribute
     * @param array $content
     * @return void
     */
    public function initialize($contentObjectAttribute, $currentVersion, $originalContentObjectAttribute, &$content);

    /**
     * @param eZHTTPTool $http
     * @param string $action
     * @param eZContentObjectAttribute $contentObjectAttribute
     * @param array $parameters
     * @return void
     */
    public function action($http, $action, $contentObjectAttribute, $parameters);

    /**
     * @param eZContentObjectAttribute $contentObjectAttribute
     * @param array $content
     * @return void
     */
    public function remove($contentObjectAttribute, &$content);

    /**
     * @param eZContentObjectAttribute $contentObjectAttribute
     * @param null|int $version
     * @param array $content
     * @return void
     */
    public function delete($contentObjectAttribute, $version,  &$content);

}