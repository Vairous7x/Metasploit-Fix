#!/data/data/com.termux/files/usr/bin/bash

clear
echo 'Loading....'
sleep 4
apt install figlet -y
echo "Done..."
sleep 3
echo "Start Metasploit Fixing....."
sleep 5
if [ ! -d "$HOME/storage" ]
then
    termux-setup-storage
fi

termux-change-repo

apt update && apt upgrade -y
clear
echo "Please Wait...."
sleep 3
pkg install -y  wget curl openssh git
clear
pkg install ncurses-utils -y
clear
if [ ! -d "$PREFIX/opt" ]
then
    echo "Wait to create folder ...."
    mkdir $PREFIX/opt
fi


clear
printf "\e[92m"
figlet  -f standard "Vairous 7x"
printf "BY: Nour eldin\n"
printf "\e[0m"
center() {
  termwidth=$(stty size | cut -d" " -f2)
  padding="$(printf '%0.1s' ={1..500})"
  printf '%*.*s %s %*.*s\n' 0 "$(((termwidth-2-${#1})/2))" "$padding" "$1" 0 "$(((termwidth-1-${#1})/2))" "$padding"
}

center " Loading..."
source <(echo "c3Bpbm5lcj0oICd8JyAnLycgJy0nICdcJyApOwoKY291bnQoKXsKICBzcGluICYKICBwaWQ9JCEKICBmb3IgaSBpbiBgc2VxIDEgMTBgCiAgZG8KICAgIHNsZWVwIDE7CiAgZG9uZQoKICBraWxsICRwaWQgIAp9CgpzcGluKCl7CiAgd2hpbGUgWyAxIF0KICBkbyAKICAgIGZvciBpIGluICR7c3Bpbm5lcltAXX07IAogICAgZG8gCiAgICAgIGVjaG8gLW5lICJcciRpIjsKICAgICAgc2xlZXAgMC4yOwogICAgZG9uZTsKICBkb25lCn0KCmNvdW50" | base64 -d)
echo
center "*** Dependencies installation..."
apt purge ruby -y
rm -fr $PREFIX/lib/ruby/gems

pkg upgrade -y -o Dpkg::Options::="--force-confnew"
pkg install -y binutils python autoconf bison clang coreutils curl findutils apr apr-util postgresql openssl readline libffi libgmp libpcap libsqlite libgrpc libtool libxml2 libxslt ncurses make ncurses-utils ncurses git wget unzip zip tar termux-tools termux-elf-cleaner pkg-config git ruby -o Dpkg::Options::="--force-confnew"

pip install requests

echo
center "*** Fix ruby BigDecimal"
source <(curl -sL https://github.com/termux/termux-packages/files/2912002/fix-ruby-bigdecimal.sh.txt)
echo

if [ -d "$PREFIX/opt/metasploit-framework" ]
then
    center "*** Erasing old metasploit folder..."
    rm -rf $PREFIX/opt/metasploit-framework
    echo "Done ..."
fi

echo
center "*** Downloading..."
cd $PREFIX/opt
git clone https://github.com/rapid7/metasploit-framework.git --depth=1
echo
center "*** Installation..."
cd $PREFIX/opt/metasploit-framework

gem install bundler
declare NOKOGIRI_VERSION=$(cat Gemfile.lock | grep -i nokogiri | sed 's/nokogiri [\(\)]/(/g' | cut -d ' ' -f 5 | grep -oP "(.).[[:digit:]][\w+]?[.].")

gem install nokogiri -v $NOKOGIRI_VERSION -- --use-system-libraries

bundler config build.nokogiri "--use-system-libraries --with-xml2-include=$PREFIX/include/libxml2"; bundle install

gem install actionpack
bundler update activesupport
bundler update --bundler
bundler install -j$(nproc --all)
bundle update --bundler

if [ -e $PREFIX/bin/msfconsole ];then
	rm $PREFIX/bin/msfconsole
fi
if [ -e $PREFIX/bin/msfvenom ];then
	rm $PREFIX/bin/msfvenom
fi
if [ -e $PREFIX/bin/msfrpcd ];then
	rm $PREFIX/bin/msfrpcd
fi
ln -s $PREFIX/opt/metasploit-framework/msfconsole $PREFIX/bin/
ln -s $PREFIX/opt/metasploit-framework/msfvenom $PREFIX/bin/
ln -s $PREFIX/opt/metasploit-framework/msfrpcd $PREFIX/bin/

termux-elf-cleaner $PREFIX/lib/ruby/gems/*/gems/pg-*/lib/pg_ext.so

echo
center "*"
echo -e "\033[32m Suppressing Warnings\033[0m"

sed -i '86 {s/^/#/};96 {s/^/#/}' $PREFIX/lib/ruby/gems/3.1.0/gems/concurrent-ruby-1.0.5/lib/concurrent/atomic/ruby_thread_local_var.rb
sed -i '442, 476 {s/^/#/};436, 438 {s/^/#/}' $PREFIX/lib/ruby/gems/3.1.0/gems/logging-2.3.1/lib/logging/diagnostic_context.rb
cd $HOME
center "*"
echo -e "\033[32m Installation complete..! \nNow You Can Launch Metasploit by Executing: msfconsole\033[0m"
center "*"


