#!/bin/bash
BASE_PATH='../../../'
declare -A FILES
FILES['kibi-distribution/gradle.properties']="kibiVersion=";
FILES['kibi-enterprise/kibi-gremlin-server/manifest.yml']="build\/libs\/gremlin-es2-server-";
FILES['kibi-enterprise/kibi-gremlin-server/pom.xml']="<version>";
FILES['kibi-enterprise/kibi-plugins/gradle.properties']="kibiVersion=";
FILES['kibi-internal/docs/index.asciidoc']=":kibi-version: ";
FILES['kibi-internal/package.json']="\"kibi_version\": \"";
FILES['kibi-internal/README.md']="# Kibi ";
FILES['sentinl-private/package.json']="\"version\": \""

#/
#/ update-package-version.sh
#/ Takes two version numbers and replaces the first with the second
#/ in specific files
#/
#/ Usage: ./update-package-versions.sh 1.2.3 1.2.4
#/ Changes all 1.2.3 versions to 1.2.4
#/
usage() {
    grep '^#/' "$0" | cut -c4-
    exit 0
}
expr "$*" : ".*--help" > /dev/null && usage


if [ "$#" -ne 2 ]
then
  echo "Wrong number of arguments: You need to specify two versions as arguments...."
  usage
  exit 1
fi

oldVersion=$1
newVersion=$2

function replaceVersions {
  file=$1
  context=$2
  echo "Replacing ${context}${oldVersion} with ${context}${newVersion} in ${file}"
  sed -i -e "s/${context}${oldVersion}/${context}${newVersion}/g" ${BASE_PATH}${file}
  cat ${BASE_PATH}${file}
}

for i in "${!FILES[@]}"; do
  replaceVersions $i "${FILES[$i]}"
done
