.. highlight:: rst

.. _records_language_java_open-source_mockito:















使用异常
:::::::::::

1. Mockito: InvalidUseOfMatchersException

::

    The error message outlines the solution pretty clearly. The line
    doNothing().when(cmd).dnsCheck(HOST, any(InetAddressFactory.class))

    uses one raw value and one matcher, when it's required to use either all raw values or all matchers. A correct version might read
    doNothing().when(cmd).dnsCheck(eq(HOST), any(InetAddressFactory.class))

    HOST 使用maither.eq包围
