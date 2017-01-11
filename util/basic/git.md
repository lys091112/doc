

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
    5. git rebase -i origin/master rebase Master分支代码到本地分支,然后提交push
        
    
### git高级使用
#### 1. git subtree 使用

    1. 从ai-dm删除想要抽离的文件并commit到本地
    2. 列出所有删除的文件 (git show --pretty="" --name-only <SHA1> > keep-these.txt)
    3. 将ai-dm clone到新项目文件夹 agent-cmd-service //git clone git@git.com/ai-dm.git agent-cmd-service
    4. 把第2步生成的keep-these.txt移动到agent-cmd-service，在agent-cmd-service下运行如下命令
        git filter-branch --force --index-filter \
        "git rm --ignore-unmatch --cached -qr . ; \
        cat $PWD/keep-these.txt | xargs git reset -q \$GIT_COMMIT --" \
        --prune-empty --tag-name-filter cat -- --all
    5. git remote add origin git@scm.oneapm.me:ai/agent-command-service.git
    6. git push origin master
    7. 切换到application-insight/
    8. git remote add cmd-service git@scm.oneapm.me:ai/agent-command-service.git
    9. git subtree add --prefix=agent-cmd-service cmd-service maste

    注意: 从subtree进行更新
    git subtree pull --prefix=agent-cmd-service --squash cmd-service master
    git subtree push --prefix=agent-cmd-service --squash cmd-service master
    参数解析: agent-cmd-service 在application-insight下关联的subtree目录
             cmd-service 关联的subtree的远程节点别名
             master 远程subtree分支名称

#### 2. git submodule 使用

    1. git submodule add 仓库地址 路径  #路径不能以/结尾
    2. git submodule update --init --recursive  #git clone 之后需要手动加载submodule代码
    3. submodule的删除稍微麻烦点：首先，要在“.gitmodules”文件中删除相应配置信息。
       然后，执行“git rm –cached ”命令将子模块所在的文件从git中删除
