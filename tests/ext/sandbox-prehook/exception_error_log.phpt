--TEST--
[Prehook Regression] Exception in tracing closure gets logged
--SKIPIF--
<?php if (PHP_VERSION_ID < 70000) die('skip: Prehook not supported on PHP 5'); ?>
--ENV--
SIGNALFX_TRACE_DEBUG=1
DD_TRACE_TRACED_INTERNAL_FUNCTIONS=array_sum
--FILE--
<?php
DDTrace\trace_function('array_sum', ['prehook' => function () {
    throw new RuntimeException("This exception is expected");
}]);
$sum = array_sum([1, 3, 5]);
var_dump($sum);
?>
--EXPECT--
RuntimeException thrown in ddtrace's closure for array_sum(): This exception is expected
int(9)
