FROM ubuntu:22.04

ARG TTSBotVer=0.3.0
ARG MMDAgentVer=1.8

WORKDIR /TTSBot/
#日本語ログが文字化けするのでUbuntuを日本語設定に
RUN apt-get update \
    && apt-get install -y locales \
    && locale-gen ja_JP.UTF-8 \
    && echo "export LANG=ja_JP.UTF-8" >> ~/.bashrc
ENV LANG ja_JP.utf8

RUN apt update -y &&\
    apt install -y wget unzip default-jre open-jtalk open-jtalk-mecab-naist-jdic hts-voice-nitech-jp-atr503-m001
RUN wget http://sourceforge.net/projects/mmdagent/files/MMDAgent_Example/MMDAgent_Example-${MMDAgentVer}/MMDAgent_Example-${MMDAgentVer}.zip &&\
     unzip MMDAgent_Example-${MMDAgentVer}.zip &&\
     cp -r ./MMDAgent_Example-${MMDAgentVer}/Voice/**/*.htsvoice /usr/share/hts-voice/ &&\ 
     rm -rf MMDAgent_Example-${MMDAgentVer}.zip MMDAgent_Example-${MMDAgentVer}/ &&\
    #本体インストール(jarファイル)
    wget -P /usr/bin/ https://github.com/Cosgy-Dev/TextToSpeakBot/releases/download/${TTSBotVer}/TextToSpeak-${TTSBotVer}-All.jar

ENV TTSBotVer ${TTSBotVer}
#コンフィグ書き込み(/TTSBotディレクトリにconfig.txtがない場合)→Bot起動
CMD if [ ! -e /TTSBot/config.txt ]; then \
        echo "\
/// START OF YOMIAGEBOT CONFIG ///\n\
token = ${token}\n\
owner = ${owner}\n\
prefix = \"${prefix}\"\n\
altprefix = \"${altprefi:-なし}\"\n\
game = \"${game:-DEFAULT}\"\n\
status = ${discordstatus:-ONLINE}\n\
updatealerts = ${updatealerts:-true}\n\
dictionary = \"${dictionary:-/var/lib/mecab/dic/open-jtalk/naist-jdic}\"\n\
voiceDirectory = \"${voiceDirectory:-/usr/share/hts-voice}\"\n\
alonetimeuntilstop = ${alonetimeuntilstop:-0}\n\
maxmessagecount = ${maxmessagecount:-0}\n\
/// END OF YOMIAGEBOT CONFIG ///\n\
        " > /TTSBot/config.txt;\
    fi &&\
    cat /TTSBot/config.txt && java -jar -Dnogui=true /usr/bin/TextToSpeak-${TTSBotVer}-All.jar