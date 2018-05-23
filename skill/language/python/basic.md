# python 基础使用

- **python base64数据处理**

``` python
    import base64

    base64.b64decode('xxx')
    base64.b64encode('xxx')
```

-  **python 调用shell命令**

``` python

   import os
   os.system('ls')

   os.popen('ls').read().split('\n')

   import commands
   status, result = commands.getstatusoutput('ls')
   print(result)

```

```sh
    #!/bin/bash

    #hello.sh
    echo "hello,world ${1} ${2}"
    exit 0
```

``` python 
    #!/usr/bin/env python

    import os
    import sys

    if(len(sys.argv) < 3) 
        print "please input two arguments"
        sys.exit(1)

    # argv[0] is .py file
    args_1 = sys.argv[1]
    args_2 = sys.argv[2]
    os.system('./hello.sh ' + args_1 + ' ' + args_2)
```
