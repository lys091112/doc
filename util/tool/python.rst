.. _python_util:

记录python的一些使用小技巧
---------------------------


``Base64``

.. code-block:: python

    import base64
    a = base64.b64encode()
    print (a)
    print base64.b64decode("aGVsbG8sIHdvcmxkCg==")
