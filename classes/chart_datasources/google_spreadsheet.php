<?php

use Google\Spreadsheet\DefaultServiceRequest;
use Google\Spreadsheet\ServiceRequestFactory;
use Google\Spreadsheet\SpreadsheetService;

class OCChartDataSourceGoogleSpreadsheet implements OCChartDataSourceInterface
{
    public function getIdentifier()
    {
        return 'google_spreadsheet';
    }

    public function getName()
    {
        return "Public Google Spreadsheet";
    }

    public function downloadCsvData($contentObjectAttribute, $version, $content)
    {
        if (isset($content['data_source_params']['worksheet_id']) && $content['data_source_params']['selected_sheet']) {
            $googleSpreadsheetId = $content['data_source_params']['worksheet_id'];
            $serviceRequest = new DefaultServiceRequest("");
            ServiceRequestFactory::setInstance($serviceRequest);
            $spreadsheetService = new SpreadsheetService();
            $worksheetFeed = $spreadsheetService->getPublicSpreadsheet($googleSpreadsheetId);
            try {
                $worksheet = $worksheetFeed->getByTitle($content['data_source_params']['selected_sheet']);
                echo $worksheet->getCsv();
            }catch (Exception $e){
                echo $e->getMessage();
            }
        }
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
            case 'select_url' :
                {
                    $postUrlName = 'ContentObjectAttribute' . "_spreadsheet_url_" . $contentObjectAttribute->attribute("id");
                    if($http->hasPostVariable($postUrlName)) {
                        $url = $http->postVariable($postUrlName);

                        $info = $this->getSpreadsheetInfo($url);
                        $info['spreadsheet_url'] = $url;

                        // if (count($info['sheets']) == 1){
                        //     $info['selected_sheet'] = $info['sheets'][0];
                        //     $content['data_source_is_valid'] = true;
                        // }

                        $content = $contentObjectAttribute->content();
                        $content['data_source_params'] = $info;
                        $contentObjectAttribute->setContent($content);
                        $contentObjectAttribute->store();
                    }
                }
                break;

            case 'delete_url' :
                {
                    $content = $contentObjectAttribute->content();
                    $content['data_source_params'] = array();
                    $content['data_source_is_valid'] = false;
                    $contentObjectAttribute->setContent($content);
                    $contentObjectAttribute->store();
                }
                break;

            case 'select_sheet' :
                {
                    $postSheetName = 'ContentObjectAttribute' . "_spreadsheet_sheet_" . $contentObjectAttribute->attribute("id");
                    if($http->hasPostVariable($postSheetName)) {
                        $content = $contentObjectAttribute->content();
                        $content['data_source_params']['selected_sheet'] = $http->postVariable($postSheetName);
                        $content['data_source_is_valid'] = true;
                        $contentObjectAttribute->setContent($content);
                        $contentObjectAttribute->store();
                    }
                }
                break;

            case 'delete_sheet' :
                {
                    $content = $contentObjectAttribute->content();
                    unset($content['data_source_params']['selected_sheet']);
                    $contentObjectAttribute->setContent($content);
                    $contentObjectAttribute->store();
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

    private function getSpreadsheetInfo($googleSpreadsheetUrl)
    {
        $googleSpreadsheetTemp = explode('/',
            str_replace('https://docs.google.com/spreadsheets/d/', '', $googleSpreadsheetUrl));
        $googleSpreadsheetId = array_shift($googleSpreadsheetTemp);

        $serviceRequest = new DefaultServiceRequest("");
        ServiceRequestFactory::setInstance($serviceRequest);
        $spreadsheetService = new SpreadsheetService();

        $data = array();
        $data['worksheet_id'] = $googleSpreadsheetId;
        $worksheetFeed = $spreadsheetService->getPublicSpreadsheet($googleSpreadsheetId);
        $data['title'] = (string)$worksheetFeed->getXml()->title;
        $entries = $worksheetFeed->getEntries();
        $data['sheets'] = array();
        foreach ($entries as $entry){
            $data['sheets'][] = $entry->getTitle();
        }

        return $data;
    }
}