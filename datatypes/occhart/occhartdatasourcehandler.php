<?php

class OCChartDataSourceHandler
{
    private static $dataSource;

    /**
     * @return OCChartDataSourceInterface[]
     */
    public static function loadDataSources()
    {
        if (self::$dataSource === null) {
            $dataSources = array();
            $ini = eZINI::instance('occhart.ini');
            foreach ($ini->variable('DataSourceList', 'PhpClasses') as $phpClass) {
                if (class_exists($phpClass)) {
                    $dataSource = new $phpClass;
                    if ($dataSource instanceof OCChartDataSourceInterface) {
                        $dataSources[$dataSource->getIdentifier()] = $dataSource;
                    }else{
                        eZDebug::writeError("PHP class $phpClass must implement OCChartDataSourceInterface", __METHOD__);
                    }
                }else{
                    eZDebug::writeError("PHP class $phpClass not found", __METHOD__);
                }
            }
            self::$dataSource = $dataSources;
        }

        return self::$dataSource;
    }

    public static function availableDataSourceList()
    {
        $dataSources = array();
        foreach (self::loadDataSources() as $identifier => $dataSource){
            $dataSources[$identifier] = $dataSource->getName();
        }

        return $dataSources;
    }

    /**
     * @param $identifier
     * @return bool
     */
    public static function exists($identifier)
    {
        $dataSources = self::loadDataSources();
        return isset($dataSources[$identifier]);
    }

    /**
     * @param $identifier
     * @return null|OCChartDataSourceInterface
     */
    public static function get($identifier)
    {
        $dataSources = self::loadDataSources();
        return isset($dataSources[$identifier]) ? $dataSources[$identifier] : null;
    }
}