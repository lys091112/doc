

git 初始化工作
* git config --global user.name "xianyue"
* git config --global user.email "lys091112@gmail.com"
* git config --global core.editor vim  (指定git rebase默认使用的编辑器)
* git config --global credential.helper store (会默认在下次执行时，记忆上次的提交密码)

## 基本命令
    
    1. git branch -d test(本地分支） 删除本地分支 
    2. git push origin --delete test(远程分支） 删除远程分支
    3. git commit合并 -i (代表的是不包含的commit的hash值)
        - git rebase -i HEAD~3 (合并前3个commit)
        - git rebase -i 8dc36db (指定某一个commit，但不包括该commit进行合并）
    4. git cherry-pick #合并某个单独的commit
        将A.commit(hash:xxx1) 合并到B，如果有冲突，那么手动解决冲突。命令如下：
        git checkout B; git cherry-pick xxx1
        可以使用命令：git cherry-pick --abort 来撤销cherry-pick的进行
    * git rebase -i origin/master rebase Master分支代码到本地分支,然后提交push
        
    

