#!/bin/bash
#basic variable verb="patch" url=""
# nexus发布的标识，通过id来查询mvn中设置的nexus帐号密码
repositoryId=""

# nexus IP地址
nexusAdress="10.128.7.197"

#release or snapshot
releaseType=$2 

#version
version=$1

if [ "$version" = "" ]
then
    echo " please input product version."
    echo " Example: "
    echo "      sh build.sh 0.0.0.2 release"
    exit 0
fi

if [ "$releaseType" = "release" ] 
then
    verb=$version-RELEASE
    url="http://$nexusAdress:8081/nexus/content/repositories/releases"
    repositoryId=local-releases
else
    verb=$version-SNAPSHOT
    url="http://$nexusAdress:8081/nexus/content/repositories/snapshots"
    repositoryId=local-snapshots
    releaseType=snapshot
fi

echo "*****************************************************"
echo ""
echo "            Deploy Type   : "$releaseType"          "
echo "            Depoly Version: "$verb"                     "
echo ""
echo "*****************************************************"
read -p "Is All Right? [y/n]: " chioce 
if [ $chioce = no ] || [ $chioce = n ] || [ "$choice" = N ]
then
    exit 0
fi


# ./build.sh
npm run build

mvn deploy:deploy-file            \
  -Dfile=./latest.zip             \
  -DgroupId=com.blueocn.tps-ui    \
  -DartifactId=ent-ai             \
  -Dversion=$verb                 \
  -Dpackaging=zip                 \
  -Durl=${url}                    \
  -DrepositoryId=$repositoryId

