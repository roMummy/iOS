#! /bin/bash

# 是否编译工作空间 (例:若是用Cocopods管理的.xcworkspace项目,赋值true;用Xcode默认创建的.xcodeproj,赋值false)
is_workspace="true"

# .xcworkspace的名字，如果is_workspace为true，则必须填。否则可不填
workspace_name="XSLSWorkClient"

# .xcodeproj的名字，如果is_workspace为false，则必须填。否则可不填
project_name="XSLSWorkClient"



echo -e "\033[32mPlace enter the number you want build Project? 1: N端 2: M端 3: 1端\033[0m"
read projNumber
while([[ $projNumber != 1 ]] && [[ $projNumber != 2 ]] && [[ $projNumber != 3 ]])
do
echo -e "\033[31mError! Should enter 1~3 \033[0m"
echo -e "\033[32mPlace enter the number you want build Project? 1: N端 2: M端 3: 1端\033[0m"
read projNumber
done

# 指定项目的scheme名称（也就是工程的target名称），必填
if [ $projNumber == 1 ]; then
scheme_name="XSLSWorkClientBailiff"
fi

if [ $projNumber == 2 ]; then
scheme_name="XSLSWorkClientPresident"
fi

if [ $projNumber == 3 ]; then
scheme_name="XSLSWorkClientClerk"
fi

echo -e "\033[32mPlace enter the number you want build mode? 1: Debug 2: Alpha 3: Beta 4:Release\033[0m"
read buildNumber
while([[ $buildNumber != 1 ]] && [[ $buildNumber != 2 ]] && [[ $buildNumber != 3 ]] && [[ $buildNumber != 4 ]])
do
echo -e "\033[31mError! Should enter 1~4 \033[0m"
echo -e "\033[32mPlace enter the number you want build mode? 1: Debug 2: Alpha 3: Beta 4:Release\033[0m"
read buildNumber
done

# 指定要打包编译的方式 : Release/Debug。必填
if [ $buildNumber == 1 ]; then
build_configuration="Debug"
fi

if [ $buildNumber == 2 ]; then
build_configuration="Alpha"
fi

if [ $buildNumber == 3 ]; then
build_configuration="Beta"
fi

if [ $buildNumber == 4 ]; then
build_configuration="Release"
fi

echo "指定要打包编译的方式 : ${build_configuration}"

echo -e "\033[32mPlace enter the number you want to export ? 1:app-store 2:ad-hoc 3:development 4:enterprise 5:gitlog\033[0m"
read number
while([[ $number != 1 ]]  && [[ $number != 2 ]] && [[ $number != 3 ]]  && [[ $number != 4 ]]  && [[ $number != 5 ]])
do
echo -e "\033[32mPlace enter the number you want to export ?1:app-store 2:ad-hoc 3:development 4:enterprise 5:gitlog\033[0m"
read number
done

if [ $number == 1 ] ; then
method="app-store"
fi

if [ $number == 2 ] ; then
method="ad-hoc"
fi

if [ $number == 3 ] ; then
method="development"
fi

if [ $number == 4 ] ; then
method="development"
fi


#  下面两个参数只是在手动指定Pofile文件的时候用到，如果使用Xcode自动管理Profile,直接留空就好
# (跟method对应的)mobileprovision文件名，需要先双击安装.mobileprovision文件.手动管理Profile时必填 
mobileprovision_name=""
# 项目的bundleID，手动管理Profile时必填
bundle_identifier=""

echo "--------------------脚本配置参数检查--------------------"
echo -e "\033[33;1mis_workspace=${is_workspace}"
echo "workspace_name=${workspace_name}"
echo "project_name=${project_name}"
echo "scheme_name=${scheme_name}"
echo "build_configuration=${build_configuration}"
echo "method=${method}"
echo -e "mobileprovision_name=${mobileprovision_name} \033[0m"

# =======================脚本的一些固定参数定义(无特殊情况不用修改)====================== #

# 获取当前脚本所在目录
script_dir=$(cd `dirname $0`;pwd)
# 工程根目录
project_dir=$script_dir

# 时间
DATE=`date '+%Y%m%d_%H%M%S'`
# 指定输出导出文件夹路径
export_path="${project_dir}/Package/${build_configuration}/${scheme_name}-${DATE}"
# 指定输出归档文件路径
export_archive_path="${export_path}/${scheme_name}.xcarchive"
# 指定输出ipa文件夹路径
export_ipa_path="${export_path}"
# 指定输出ipa名称
ipa_name="${scheme_name}_${DATE}"
# 指定导出ipa包需要用到的plist配置文件的路径
export_options_plist_path="${project_dir}/ExportOptions.plist"

dSYM_path="${export_archive_path}/dSYMs/${scheme_name}.app.dSYM"
new_dSYM_path="${export_path}/${scheme_name}.app.dSYM"
zip_dSYM_path="$export_path/$scheme_name.app.dSYM.zip"

echo "--------------------脚本固定参数检查--------------------"
echo -e "\033[33;1m project_dir=${project_dir}"
echo "DETE=${DATE}"
echo "export_path=${export_path}"
echo "export_archive_path=${export_archive_path}"
echo "export_ipa_path=${export_ipa_path}"
echo "export_options_plist_path=${export_options_plist_path}"
echo "ipa_name=${ipa_name}"
echo -e "zip_dSYM_path=${zip_dSYM_path} \033[0m"

# =======================自动打包部分(无特殊情况不用修改)====================== #
echo "------------------------------------------------------"
echo -e "\033[32m开始构建项目  \033[0m"
# 进入项目工程目录
cd ${project_dir}

# 指定输出文件目录不存在则创建
if [ -d "export_path" ]; then
	echo $export_path
else
	mkdir -pv $export_path
fi

if [ $number == 5 ]; then

#移除中间转换文件
rm -f $temp_txt

#打开文件夹
open $export_path
open $txt_path

exit 0
fi

# 判断编译的项目类型是workspace还是project
if $is_workspace; then
# 编译前清理工程
xcodebuild clean -workspace ${workspace_name}.xcworkspace \
-scheme ${scheme_name} \
-configuration ${build_configuration}

xcodebuild archive -workspace ${workspace_name}.xcworkspace \
-scheme ${scheme_name} \
-configuration ${build_configuration} \
-archivePath ${export_archive_path}
else
# 编译前清理工程
xcodebuild clean -projcet ${project_name}.xcodeproj \
-scheme ${scheme_name} \
-configuration ${configuration_name} 

xcodebuild archive -project ${project_name}.xcodeproj \
-scheme ${scheme_name} \
-configuration ${build_configuration}
fi

#  检查是否构建成功
#  xcarchive 实际是一个文件夹不是一个文件所以使用 -d 判断
if [ -d "$export_archive_path" ]; then
echo -e "\033[32;1m项目构建成功 🚀 🚀 🚀  \033[0m"
else 
echo -e "\033[31;1m项目构建失败 😢 😢 😢  \033[0m"
exit 1
fi

echo "------------------------------------------------------"
echo -e "\033[32m开始导出ipa文件 \033[0m"

# 先删除export_options_plist文件
if [ -f "$export_options_plist_path" ]; then
echo "${export_options_plist_path}文件存在，进行删除"
rm -f $export_options_plist_path
fi
# 根据参数生成export_options_plist文件
/usr/libexec/PlistBuddy -c "Add :method String ${method}" $export_options_plist_path
/usr/libexec/PlistBuddy -c "Add :provisioningProfiles dict" $export_options_plist_path
/usr/libexec/PlistBuddy -c "Add :provisioningProfiles:${bundle_identifier} String ${mobileprovision_name}" $export_options_plist_path
/usr/libexec/PlistBuddy -c "Add :compileBitcode bool NO" $export_options_plist_path
#/usr/libexec/PlistBuddy -c "print" export_options_plist_path

xcodebuild -exportArchive \
-archivePath ${export_archive_path} \
-exportPath ${export_ipa_path} \
-exportOptionsPlist ${export_options_plist_path} \
-allowProvisioningUpdates

# 检查ipa文件是否存在
if [ -f "$export_ipa_path/$scheme_name.ipa" ]; then
echo -e "\033[32;1mexprotArchive ipa包成功，准备进行重命名\033[0m"
else 
echo -e "\033[31;1mexportArchive ipa包失败 😢 😢 😢   \033[0m"
exit 1
fi

# 修改ipa文件名称
mv $export_ipa_path/$scheme_name.ipa $export_ipa_path/$ipa_name.ipa

# 检查文件是否存在
if [ -f "$export_ipa_path/$ipa_name.ipa" ]; then
echo "导出 ${ipa_name}.ipa 包成功"
open $export_path
else
echo -e "\033[31;1m导出 ${ipa_name}.ipa 包失败 😢 😢 😢     \033[0m"
exit 1
fi

# 删除export_options_plist文件（中间文件）
if [ -f "$export_options_plist_path" ]; then
echo "${export_options_plist_path}文件存在，准备删除"
rm -f $export_options_plist_path
fi


# 输出打包总用时
echo -e "\033[36;1m本次自动打包总用时: ${SECONDS}s \033[0m"

#准备上传dSYM文件到 bugly

if [ $number == 1 ]; then
echo "==========准备上传ipa到App Store============"
#验证并上传到App Store，将-u 后面的XXX替换成自己的AppleID的账号，-p后面的XXX替换成自己的密码
echo -e "\033[31m请输入AppleID的账号\033[0m"
read account
echo -e "\033[31m请输入AppleID的账号密码\033[0m"
read password
altoolPath = "/Applications/Xcode.app/Contents/Applications/Applications Loader.app/Contents/Frameworks/ITunesSoftwareService.framework/Versions/A/Support/altool"
"$altoolPath" --validate-app -f ${ipa_name}.ipa -u appid账号 -p $account -t ios --output0format xml
"$altoolPath" --upload-app -f ${ipa_name}.ipa -u appid账号 -p $password -t ios --output-format xml
else 
echo "\033[33m==========准备上传ipa到fir============ \033[0m"


#移除中间转换文件
rm -f $temp_txt
fi

#打开文件夹
open $export_path
open $txt_path

exit 0




























