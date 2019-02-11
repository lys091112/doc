.. highlight:: rst

.. _records_base_https-certification-convert:

https 证书转化
-----------------

pcks7 to cer
================

::

    # 将证书从der格式转化为pem格式
    1. openssl pkcs7 -inform der -in _.anjuke.test -out safaricom_b2c_readable.p7b

    # 提取证书
    2. openssl pkcs7 -print_certs  -in safaricom_b2c_readable.p7b -out safaricom_b2c_readable.cer
