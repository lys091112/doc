.. _records_regex_character-set:

字符组
^^^^^^^

.. toctree::
  :maxdepth: 2
  :glob:

1. 普通字符组

   1. 普通字符组通过中括号包围[ab],表达的意思是a或b任意一个字符都匹配，
   2. 可以使用短线 '-' 来标识范围，如[a-z],标识a到z内的所有字符，'-' 匹配的是两边的码值，从而进行可以从大到小的匹配

2. 元字符

::
    常见的元字符有：[,],^,$ 都是元字符，因此在用作字符匹配是，需要对其进行转义，一般是使用反斜杠进行转义


3. 排除型字符

::
    排除性字符组，写作[^...] ,用来排除该字符组内的字符，非字符组内的字符都可以进行匹配
    如果需要排除'-',那么'-'需要紧跟在[后。 如[-09]


4. 字符组简记

::

    \d == [0-9] 代表数字  也可以写成[^\d] 来排除数字
    \s == [\t\r\n\v\f] 代表空白符 [^\s] 来排除空白符
    \w == [a-zA-Z]   代表英文字符  [^\w] 排除字符

    \D,\S ,\W 代表和其小写相反的含义


5. 字符组运算

::

    JAVA    [[a-z]&&[^aeiou]] 排除所有的元音字符，

6. POSIX 字符组

::

    ... 自行查阅
