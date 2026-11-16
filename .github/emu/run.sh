#!/bin/bash
# Install the APK, open the app, screenshot welcome / keyboard-open / sidebar, dump web metrics.
set -x
APK=$1; OUT=$2; mkdir -p $OUT
D=$(dirname "$0")
adb wait-for-device
adb shell getprop ro.build.version.release | tee $OUT/android.txt
adb shell dumpsys webviewupdate | tee $OUT/webview.txt | head -20
# gesture navigation, soft keyboard even with the emulator's hardware keyboard
adb shell cmd overlay enable com.android.internal.systemui.navbar.gestural || true
adb shell settings put secure show_ime_with_hard_keyboard 1
sleep 3
adb install -r "$APK"
adb shell am start -W -n com.mubu.dschat/.MainActivity
sleep 12
adb exec-out screencap -p > $OUT/0-launch.png
PID=$(adb shell pidof com.mubu.dschat | tr -d '\r')
adb forward tcp:9222 localabstract:webview_devtools_remote_$PID
python3 $D/cdp.py setup || true
sleep 6
adb exec-out screencap -p > $OUT/1-welcome.png
python3 $D/cdp.py metrics > $OUT/1-welcome.json || true
adb shell uiautomator dump /sdcard/ui.xml >/dev/null; adb pull /sdcard/ui.xml $OUT/1-ui.xml
# tap the textarea (its accessibility node), keyboard should open
XY=$(python3 $D/find.py $OUT/1-ui.xml EditText)
adb shell input tap $XY
sleep 5
adb exec-out screencap -p > $OUT/2-keyboard.png
python3 $D/cdp.py metrics > $OUT/2-keyboard.json || true
adb shell dumpsys input_method | grep -i "mInputShown\|isInputViewShown" > $OUT/2-ime.txt
adb shell input text hello
sleep 2
adb exec-out screencap -p > $OUT/3-typed.png
adb shell input keyevent 4
sleep 3
adb exec-out screencap -p > $OUT/4-keyboard-closed.png
python3 $D/cdp.py metrics > $OUT/4-closed.json || true
adb shell uiautomator dump /sdcard/ui2.xml >/dev/null; adb pull /sdcard/ui2.xml $OUT/4-ui.xml
XY=$(python3 $D/find.py $OUT/4-ui.xml "打开边栏|Open sidebar")
adb shell input tap $XY
sleep 3
adb exec-out screencap -p > $OUT/5-sidebar.png
adb logcat -d | grep -i "capacitor\|chromium\|SystemBars" | tail -200 > $OUT/logcat.txt
exit 0
