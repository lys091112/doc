

git 初始化工作
* git config --global user.name "xianyue"
* git config --global user.email "lys091112@gmail.com"
* git config --global core.editor vim  (指定git rebase默认使用的编辑器)
* git config --global credential.helper store (会默认在下次执行时，记忆上次的提交密码)

## 基本命令
   
    1. git branch -d test                       #删除本地分支 
    2. git push origin --delete test            #删除远程分支
    3. git commit合并                           #-i代表的是不包含的commit的hash值
        - git rebase -i HEAD~3                  #合并前3个commit)
        - git rebase -i 8dc36db                 #指定某一个commit，但不包括该commit进行合并
        - git push --force origin master        #合并分支后进行提交时,对以前提交过的记录进行强制覆盖,
        - 需要注意的是将合并后显示的分支置为pick，其他分支置为squash, 这个很重要
    4. git cherry-pick                          #合并某个单独的commit
        git checkout B; git cherry-pick xxx1    #将A.commit(hash:xxx1) 合并到B，如果有冲突，那么手动解决冲突
                                                #可以使用命令：git cherry-pick --abort 来撤销cherry-pick的进行
    5. git rebase -i origin/master rebase       #Master分支代码到本地分支,然后提交push
    6. git remote add orgin git@github.com:xx/xx.git  #添加远程仓库
    7. git remote -v                            #查看本地仓库关联的远程仓库的地址
    8. git reset --hard $commit                 #回退到某个指定的commit



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

    1. 创建新的仓库（b-service)
    2. 在a-service中添加新的远程项目（例如：git remote add bservice git@scm.xxx:me:ai/s-service.git) 
    3. 将a-service推送到新的项目（git push bservice)
    4. 进入b-service项目,删除所有跟b-service需要的无关的文件
    5. git ls-files > keep-these.log (遍历出剩余的文件)
    6. git commit -m "..."
    7. git filter-branch --force --index-filter "git rm --ignore-unmatch --cached -qr . ; \
       cat $PWD/keep-these.log | xargs git reset -q $GIT_COMMIT --" \
       --prune-empty --tag-name-filter cat -- --all (只保留文件的提交记录)
    8. git push origin master (这里orgin master 是b-service的)
    
    注意：将仓库a-service中的文件移动到仓库b-service中，并保留提交历史记录
    git submodule add 仓库地址 路径  #路径不能以/结尾
    git submodule update --init --recursive  #git clone 之后需要手动加载submodule代码
    submodule的删除稍微麻烦点：首先，要在“.gitmodules”文件中删除相应配置信息。
       然后，执行“git rm –cached ”命令将子模块所在的文件从git中删除
