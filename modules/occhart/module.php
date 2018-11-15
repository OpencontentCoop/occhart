<?php
$Module = array('name' => 'OCChart');

$ViewList = array();

$ViewList['data'] = array(
    'script' => 'data.php',
    'params' => array('AttributeId', 'AttributeVersion'),
    'functions' => array('data')
);

$FunctionList = array();
$FunctionList['data'] = array();
