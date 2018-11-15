<?php

class OCChartDataSourceBinaryFile implements OCChartDataSourceInterface
{
    public function getIdentifier()
    {
        return 'binary_file';
    }

    public function getName()
    {
        return "File CSV";
    }

    public function downloadCsvData($contentObjectAttribute, $version, $content)
    {
        $sys = eZSys::instance();
        $storage_dir = $sys->storageDirectory();
        $contentObjectAttributeID = $contentObjectAttribute->attribute("id");
        $binaryFile = eZBinaryFile::fetch($contentObjectAttributeID, $version);
        $mimeType = $binaryFile->attribute("mime_type");
        list($prefix, $suffix) = explode('/', $mimeType);
        $orig_dir = $storage_dir . "/original/" . $prefix;
        $fileName = $binaryFile->attribute("filename");
        $filePath = $orig_dir . "/" . $fileName;
        $file = eZClusterFileHandler::instance($filePath);
        if ($file->exists()){
            echo $file->fetchContents();
        }
    }

    public function hasEditTemplate()
    {
        return true;
    }

    public function initialize($contentObjectAttribute, $currentVersion, $originalContentObjectAttribute, &$content)
    {
        if ($currentVersion != false) {
            $contentObjectAttributeID = $originalContentObjectAttribute->attribute("id");
            $version = $contentObjectAttribute->attribute("version");
            $oldFile = eZBinaryFile::fetch($contentObjectAttributeID, $currentVersion);
            if ($oldFile != null) {
                $oldFile->setAttribute('contentobject_attribute_id', $contentObjectAttribute->attribute('id'));
                $oldFile->setAttribute("version", $version);
                $oldFile->store();
                $content['data_source_params'] = array(
                    'file' => $oldFile->attribute('filename'),
                    'original_filename' => $oldFile->attribute('original_filename')
                );
                $content['data_source_is_valid'] = true;
            }
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
        $this->deleteBinaryFile($contentObjectAttribute, $version);
    }

    /**
     * @param eZContentObjectAttribute $contentObjectAttribute
     * @param array $content
     * @return void
     */
    public function remove($contentObjectAttribute, &$content)
    {
        $version = $contentObjectAttribute->attribute("version");
        $this->deleteBinaryFile($contentObjectAttribute, $version);
        $content['data_source_params'] = array();
        $content['data_source_is_valid'] = false;
    }

    /**
     * @param eZHTTPTool $http
     * @param string $action
     * @param eZContentObjectAttribute $contentObjectAttribute
     * @param array $parameters
     * @return void
     */
    public function action($http, $action, $contentObjectAttribute, $parameters)
    {
        switch ($action) {
            case 'delete_binary' :
                {
                    $content = $contentObjectAttribute->content();
                    $content['data_source_params'] = array();
                    $content['data_source_is_valid'] = false;
                    $contentObjectAttribute->setContent($content);
                    $contentObjectAttribute->store();

                    $version = $contentObjectAttribute->attribute("version");
                    $this->deleteBinaryFile($contentObjectAttribute, $version);
                }
                break;
            case 'upload_binary' :
                {
                    $postFileName = 'ContentObjectAttribute' . "_data_binaryfilename_" . $contentObjectAttribute->attribute("id");
                    $version = $contentObjectAttribute->attribute("version");
                    $file = $this->uploadBinaryFile($contentObjectAttribute, $version, $postFileName);
                    if ($file instanceof eZBinaryFile) {
                        $content = $contentObjectAttribute->content();
                        $content['data_source_params'] = array(
                            'file' => $file->attribute('filename'),
                            'original_filename' => $file->attribute('original_filename')
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
     * @param int|null $version
     * @param string $postFileName
     * @return bool|eZBinaryFile
     */
    private function uploadBinaryFile($contentObjectAttribute, $version, $postFileName)
    {
        if (!eZHTTPFile::canFetch($postFileName))
            return false;

        $binaryFile = eZHTTPFile::fetch($postFileName);
        if ($binaryFile instanceof eZHTTPFile) {
            $contentObjectAttributeID = $contentObjectAttribute->attribute("id");

            $mimeData = eZMimeType::findByFileContents($binaryFile->attribute("original_filename"));
            $mime = $mimeData['name'];

            if ($mime == '') {
                $mime = $binaryFile->attribute("mime_type");
            }
            $extension = eZFile::suffix($binaryFile->attribute("original_filename"));
            if (strtolower($extension) !== 'csv'){
                return false;
            }
            $binaryFile->setMimeType($mime);
            if (!$binaryFile->store("original", $extension)) {
                eZDebug::writeError("Failed to store http-file: " . $binaryFile->attribute("original_filename"), __METHOD__);
                return false;
            }

            $binary = eZBinaryFile::fetch($contentObjectAttributeID, $version);
            if ($binary === null)
                $binary = eZBinaryFile::create($contentObjectAttributeID, $version);

            $binary->setAttribute("contentobject_attribute_id", $contentObjectAttributeID);
            $binary->setAttribute("version", $version);
            $binary->setAttribute("filename", basename($binaryFile->attribute("filename")));
            $binary->setAttribute("original_filename", $binaryFile->attribute("original_filename"));
            $binary->setAttribute("mime_type", $mime);

            $binary->store();

            $filePath = $binaryFile->attribute('filename');
            $fileHandler = eZClusterFileHandler::instance();
            $fileHandler->fileStore($filePath, 'binaryfile', true, $mime);

            return $binary;
        }

        return false;
    }

    /**
     * @param eZContentObjectAttribute $contentObjectAttribute
     * @param int|null $version
     */
    private function deleteBinaryFile($contentObjectAttribute, $version)
    {
        $contentObjectAttributeID = $contentObjectAttribute->attribute("id");
        $sys = eZSys::instance();
        $storage_dir = $sys->storageDirectory();

        if ($version == null) {
            $binaryFiles = eZBinaryFile::fetch($contentObjectAttributeID);
            eZBinaryFile::removeByID($contentObjectAttributeID, null);

            foreach ($binaryFiles as $binaryFile) {
                $mimeType = $binaryFile->attribute("mime_type");
                list($prefix, $suffix) = explode('/', $mimeType);
                $orig_dir = $storage_dir . '/original/' . $prefix;
                $fileName = $binaryFile->attribute("filename");

                $binaryObjectsWithSameFileName = eZBinaryFile::fetchByFileName($fileName);

                $filePath = $orig_dir . "/" . $fileName;
                $file = eZClusterFileHandler::instance($filePath);
                if ($file->exists() and count($binaryObjectsWithSameFileName) < 1)
                    $file->delete();
            }
        } else {
            $count = 0;
            $binaryFile = eZBinaryFile::fetch($contentObjectAttributeID, $version);
            if ($binaryFile != null) {
                $mimeType = $binaryFile->attribute("mime_type");
                list($prefix, $suffix) = explode('/', $mimeType);
                $orig_dir = $storage_dir . "/original/" . $prefix;
                $fileName = $binaryFile->attribute("filename");

                eZBinaryFile::removeByID($contentObjectAttributeID, $version);

                $binaryObjectsWithSameFileName = eZBinaryFile::fetchByFileName($fileName);
                $filePath = $orig_dir . "/" . $fileName;
                $file = eZClusterFileHandler::instance($filePath);
                if ($file->exists() and count($binaryObjectsWithSameFileName) < 1)
                    $file->delete();
            }
        }
    }
}