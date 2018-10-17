.. _linux_basic_software_trx:

.. toctree::
   :maxdepth: 1
   :glob:

.. _tip:
    不好用，建议不安装

ubuntu18.04 安装rtx         
-----------------------

::

    1. 安装wine 通过apt install的提示安装
      
    2. export WINEARCH="win32" && sudo rm -rf ~/.wine    把wine设置为32位
          
    3. wget  https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks  一定要下载最新，不然可能会出现sha1sum mismatch error
     
    4.  winetricks msxml3 msxml6 riched20 riched30 ie6 vcrun6 vcrun2005sp1 安装依赖
      
    5. 下载RTX2012 http://dldir1.qq.com/foxmail/rtx/rtxclient2012formal.exe
      
    6. wine rtxclient2012formal.exe   安装rtx
     
    7. 安装完毕后可能会出现乱码，将simsun.ttc 拷贝到.wine/driver_c/windows/Fonts，
    如果不可以则复制以下内容到zh.reg,然后在终端输入 regedit zh.reg
     
        REGEDIT4
     
        [HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\Fonts]
        "Simsun"="simsun.ttc"
     
        [HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\FontLink]
        [HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\FontLink\SystemLink]
        "Lucida Sans Unicode"="simsun.ttc,simsun"
        "Microsoft Sans Serif"="simsun.ttc,simsun"
        "SimSun"="simsun.ttc,simsun"
        "Tahoma"="simsun.ttc,simsun"
     
        [HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\FontSubstitutes]
        "MS Shell Dlg"="Simsun"
        "MS Shell Dlg 2"="Simsun"
        "Tahoma"="Simsun"
     
    参考链接：https://askubuntu.com/questions/749549/winetricks-sha1sum-mismatch-rename-and-try-again
