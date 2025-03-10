#!/bin/sh

# Now in module working directory
SC_ARCH=arm64

do_build_result() {
if [ "$VERSION" = "" ]; then
	echo "version not found"
	exit 3
fi

rm -f ${MODULE}.tar.gz
#清理mac os 下文件
rm -f $MODULE/.DS_Store
rm -f $MODULE/*/.DS_Store
rm -f ${MODULE}.tar.gz

# add version to the package
cat > ${MODULE}/version <<EOF
$VERSION
EOF
cat > ${MODULE}/.arch <<EOF
$SC_ARCH
EOF

tar -zcvf ${MODULE}.tar.gz $MODULE
md5value=`md5sum ${MODULE}.tar.gz|tr " " "\n"|sed -n 1p`
cat > ./version <<EOF
$VERSION
$md5value
EOF
cat version

DATE=`date +%Y-%m-%d_%H:%M:%S`
cat > ./config.json.js <<EOF
{
"version":"$VERSION",
"md5":"$md5value",
"arch":"$SC_ARCH",
"home_url":"$HOME_URL",
"title":"$TITLE",
"description":"$DESCRIPTION",
"build_date":"$DATE"
}
EOF

#update md5
python ../softcenter/gen_install.py stage2
rm -rf ${MODULE}/version
rm -rf ${MODULE}/.arch
}
