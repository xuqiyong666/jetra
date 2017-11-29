<?php

namespace jetra\php;

error_reporting(E_ALL);

require_once __DIR__.'/lib/Thrift/ClassLoader/ThriftClassLoader.php';

use Thrift\ClassLoader\ThriftClassLoader;

$GEN_DIR = realpath(dirname(__FILE__)).'/gen-php';

$loader = new ThriftClassLoader();
$loader->registerNamespace('Thrift', __DIR__ . '/lib');
$loader->registerDefinition('jetra', $GEN_DIR);
$loader->register();

use Thrift\Protocol\TBinaryProtocol;
use Thrift\Transport\TSocket;
use Thrift\Transport\THttpClient;
use Thrift\Transport\TFramedTransport;
use Thrift\Exception\TException;

$socket = new TSocket('127.0.0.1', 9090);
$transport = new TFramedTransport($socket);
$protocol = new TBinaryProtocol($transport);
$client = new \jetra\thrift\ServiceClient($protocol);

$transport->open();

// 1. 无参数调用
$request = new \jetra\Thrift\Request(array(
  "route" => "greeting"
));

$response = $client->call($request);
var_dump($response);

// 2. 带参数调用
$request = new \jetra\Thrift\Request(array(
  "route" => "repeat",
  "params" => json_encode(
    array("msg"=>"Hear me? I am PHP.")
  )
));

$response = $client->call($request);
var_dump($response);

?>