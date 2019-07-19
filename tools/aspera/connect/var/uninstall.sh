#!/bin/sh

has() { which $1 >/dev/null 2>&1; }

killall asperaconnect.bin 2>/dev/null

rm -rf ~/.aspera/connect 2>/dev/null
if [ -z "$(ls -A ~/.aspera)" ]; then
    rm -rf ~/.aspera 2>/dev/null
fi
rm -rf ~/.config/aspera/login.key 2>/dev/null
rm -rf ~/.config/Aspera/IBM\ Aspera\ Crypt.conf 2>/dev/null

rm -rf ~/.local/share/applications/aspera-connect.desktop 2>/dev/null
has update-desktop-database && update-desktop-database ~/.local/share/applications/

rm -rf ~/.mozilla/plugins/libnpasperaweb.so 2>/dev/null
rm -rf ~/.mozilla/native-messaging-hosts/com.aspera.connect.nativemessagehost.json 2>/dev/null
rm -rf ~/.config/google-chrome/NativeMessagingHosts/com.aspera.connect.nativemessagehost.json 2>/dev/null
rm -rf ~/.config/chromium/NativeMessagingHosts/com.aspera.connect.nativemessagehost.json 2>/dev/null

echo "Uninstall finished."
