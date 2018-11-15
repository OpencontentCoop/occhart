<?php

class OCChartType extends eZDataType
{
    const DATA_TYPE_STRING = "occhart";

    function __construct()
    {
        $this->eZDataType(
            self::DATA_TYPE_STRING,
            ezpI18n::tr('occhart/attribute', 'Chart', 'Datatype name'),
            array('serialize_supported' => true)
        );
    }

    /**
     * Sets the default value.
     *
     * @param eZContentObjectAttribute $contentObjectAttribute
     * @param int $currentVersion
     * @param eZContentObjectAttribute $originalContentObjectAttribute
     */
    function initializeObjectAttribute($contentObjectAttribute, $currentVersion, $originalContentObjectAttribute)
    {
        $contentObjectAttribute->setAttribute("data_text", $originalContentObjectAttribute->attribute("data_text"));
        $content = $contentObjectAttribute->content();
        if ($content['data_source'] && OCChartDataSourceHandler::exists($content['data_source'])) {
            OCChartDataSourceHandler::get($content['data_source'])->initialize($contentObjectAttribute, $currentVersion, $originalContentObjectAttribute, $content);
        }
    }

    function isIndexable()
    {
        return false;
    }

    /**
     * @param eZHTTPTool $http
     * @param string $base
     * @param eZContentObjectAttribute $objectAttribute
     * @return bool
     */
    function fetchObjectAttributeHTTPInput($http, $base, $objectAttribute)
    {
        if ($http->hasPostVariable($base . '_occhart_config_' . $objectAttribute->attribute('id'))) {
            $data = $http->postVariable($base . '_occhart_config_' . $objectAttribute->attribute('id'));
            $content = $objectAttribute->content();
            $content['config_string'] = $data;
            $objectAttribute->setContent($content);
            return true;
        }
        return false;
    }


    /**
     * @param eZHTTPTool $http
     * @param string $action
     * @param eZContentObjectAttribute $contentObjectAttribute
     * @param array $parameters
     */
    function customObjectAttributeHTTPAction($http, $action, $contentObjectAttribute, $parameters)
    {
        switch ($action) {
            case 'select_source' :
                {
                    $availableSourceList = OCChartDataSourceHandler::availableDataSourceList();
                    $postName = 'ContentObjectAttribute' . '_occhart_select_source_' . $contentObjectAttribute->attribute('id');
                    if ($http->hasPostVariable($postName)) {
                        $selectedSource = $http->postVariable($postName);
                        if (OCChartDataSourceHandler::exists($selectedSource)) {
                            $content = $contentObjectAttribute->content();
                            $content['data_source'] = $selectedSource;
                            $contentObjectAttribute->setContent($content);
                            $contentObjectAttribute->store();
                        }
                    }
                }
                break;

            case 'remove_source' :
                {
                    $content = (array)$contentObjectAttribute->content();
                    if ($content['data_source'] && OCChartDataSourceHandler::exists($content['data_source'])) {
                        OCChartDataSourceHandler::get($content['data_source'])->remove($contentObjectAttribute, $content);
                    }
                    $content['data_source'] = false;
                    $contentObjectAttribute->setContent($content);
                    $contentObjectAttribute->store();
                }
                break;

            default :
                {
                    $dataSourceActionDetect = explode('-', $action);
                    if (isset($dataSourceActionDetect[1]) && OCChartDataSourceHandler::exists($dataSourceActionDetect[0])) {
                        OCChartDataSourceHandler::get($dataSourceActionDetect[0])->action(
                            $http, $dataSourceActionDetect[1], $contentObjectAttribute, $parameters
                        );
                    } else {
                        eZDebug::writeError('Unknown custom HTTP action: ' . $action, __METHOD__);
                    }
                }
                break;
        }
    }

    /**
     * @param eZContentObjectAttribute $contentObjectAttribute
     * @return bool
     */
    function hasObjectAttributeContent($contentObjectAttribute)
    {
        $content = $contentObjectAttribute->content();
        return $content['data_source_is_valid'];
    }

    /**
     * @param eZContentObjectAttribute $contentObjectAttribute
     */
    function storeObjectAttribute($contentObjectAttribute)
    {
        $content = $contentObjectAttribute->content();
        $contentObjectAttribute->setAttribute('data_text', json_encode($content));
    }

    /**
     * Returns the content.
     *
     * @param eZContentObjectAttribute $contentObjectAttribute
     * @return mixed|string
     */
    function objectAttributeContent($contentObjectAttribute)
    {
        $content = array(
            'data_source' => false,
            'data_source_is_valid' => false,
            'data_source_edit_template' => false,
            'data_source_params' => array(),
            'config_string' => ''
        );

        if ($contentObjectAttribute->attribute("data_text") != '') {
            $content = array_merge(
                $content,
                json_decode($contentObjectAttribute->attribute("data_text"), true)
            );
        }

        $content['source_type_list'] = OCChartDataSourceHandler::availableDataSourceList();
        if ($content['data_source'] && OCChartDataSourceHandler::exists($content['data_source'])) {
            $content['data_source_edit_template'] = OCChartDataSourceHandler::get($content['data_source'])->hasEditTemplate();
        }

        return $content;
    }

    /**
     * Returns the content.
     *
     * @param eZContentObjectAttribute $contentObjectAttribute
     * @param null|int $version
     */
    function deleteStoredObjectAttribute($contentObjectAttribute, $version = null)
    {
        $content = (array)$contentObjectAttribute->content();
        if ($content['data_source'] && OCChartDataSourceHandler::exists($content['data_source'])) {
            OCChartDataSourceHandler::get($content['data_source'])->delete($contentObjectAttribute, $version, $content);
        }
    }
}

eZDataType::register(OCChartType::DATA_TYPE_STRING, "OCChartType");
