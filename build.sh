
if [[ "_$1" == "_" ]]; then
	echo "Name of folder is required"
	exit 100
fi
folder_name=$1
mkdir ${folder_name}
cp -r `ls -ltr | grep -v "${folder_name}$" | grep -v "^total" | grep -v "build.sh" | grep -v "Jenkinsfile" | awk '{ print $9 }' ` ${folder_name}/.

tar -zcvf ${folder_name}.tar.gz ${folder_name}/.
