#!/sbin/sh

###########################
# MMT Reborn Setup
###########################

############
# Config Vars
############

# Set this to true if you don't want to mount the system folder in your module.
SKIPMOUNT=false
# Set this to true if you want to clean old files in module before flashing new module.
CLEANSERVICE=false
# Set this to true if you want to load vskel after module info print. If you want to manually load it, consider using load_vksel function.
AUTOVKSEL=false
# Set this to true if you want to debug the installation.
DEBUG=true

############
# Replace List
############

# List all directories you want to directly replace in the system.
# Construct your list in the following example format.
REPLACE_EXAMPLE="
/system/app/Youtube
/system/priv-app/SystemUI
/system/priv-app/Settings
/system/framework
"
# Construct your own list here.
REPLACE="
/system/product/etc/build.prop
/system/system_ext/etc/build.prop
/system/build.prop
/vendor/odm/etc/build.prop
/vendor/build.prop
"

############
# Permissions
############

# Set permissions.
set_permissions() {
  set_perm "$MODPATH/system/bin/proxy" 0 0 0755
  set_perm_recursive "$MODPATH/system" 0 0 0777 0755
}

############
# Info Print
############

# Set what you want to be displayed on header of installation process.
info_print() {
  ui_print ""
  print_title "change build prop"
}

############
# Main
############

# Change the logic to whatever you want.
init_main() {
#  ui_print ""
#  ui_print "Hello World!"
ui_print "[*] Initialising Setup...."

ui_print "[*] BackingUp Prop File to Internal Storage"

# Backup Code
# 源文件列表
source_files=(
    "/system/product/etc/build.prop"
    "/system/system_ext/etc/build.prop"
    "/system/build.prop"
    "/vendor/odm/etc/build.prop"
    "/vendor/build.prop"
)

# 目标目录
prop_edit_directory="/sdcard/buildpropBackup"

# 遍历源文件列表，并将每个文件复制到目标目录中
for source_file in "${source_files[@]}"
do
    if [ -f "$source_file" ]; then
        target_file="$prop_edit_directory${source_file#/*}"
        target_directory=$(dirname "$target_file")

        # 检查目标目录是否存在，如果不存在则创建目录
        if [ ! -d "$target_directory" ]; then
            mkdir -p "$target_directory"
            echo "Directory $target_directory created."
        fi

        cp "$source_file" "$target_file"
        echo "Copied $source_file to $target_file"
    else
        echo "Source file $source_file does not exist."
    fi
done

# Main Part of the script

ui_print "[*] Making Systemless Build.prop In Module"

#cp /system/build.prop /$MODPATH/system/

# 源文件列表
#source_files=(
#    "/system/product/etc/build.prop"
#    "/system/system_ext/etc/build.prop"
#    "/system/build.prop"
#    "/vendor/odm/etc/build.prop"
#    "/vendor/build.prop"
#)

# 目标目录
prop_edit_directory_formodule="/$MODPATH"

# 遍历源文件列表，并将每个文件复制到目标目录中
for source_file in "${source_files[@]}"
do
    if [ -f "$source_file" ]; then
        target_file="$prop_edit_directory_formodule${source_file#/*}"
        target_directory=$(dirname "$target_file")

        # 检查目标目录是否存在，如果不存在则创建目录
        if [ ! -d "$target_directory" ]; then
            mkdir -p "$target_directory"
            echo "Directory $target_directory created."
        fi

        cp "$source_file" "$target_file"
        echo "Copied $source_file to $target_file"
    else
        echo "Source file $source_file does not exist."
    fi
done


ui_print "[*] Done..."


ui_print "[*] Checking Installation..."
if [ -f "$MODPATH/system/build.prop" ]; then
    echo "Sucessfully Installed"
else
    echo "Something went wrong , Exiting..."
    exit 1
fi



ui_print "[*] Reboot to Use Systemless Build.prop"

ui_print "[*] All Edits to build.prop will be systemlessly perform , in case of issue just disable or Uninstall this Module"

ui_print "All Done.."
}
