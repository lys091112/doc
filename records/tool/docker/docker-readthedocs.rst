.. _docker-readthedocs:

.. toctree::
   :maxdepth: 1
   :glob:

docker compose 安装readthedocs
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

由于readthedocs的邮件模块没有配置成功， 因此采用暴力破解方式修改数据库，使用人员注册后，将注册的账号登记，然后手动修改数据库，来避过邮件验证

**执行步骤**

* docker exec -it <psql-imageid> bash

* sudo su - postgres

* psql # 登录postgresql

* \password docs  ,然后输入密码

* \connect docs 链接docs数据库

* \d 查看数据库下的表

* select * from account_emailaddress;

* update account_emailaddress set verified = 't' where id = 1; # 修改数据库，避过邮件验证
