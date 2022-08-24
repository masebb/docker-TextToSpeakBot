# TextToSpeakBotを面倒な設定いらずにDockerコンテナの上で動かす
![](https://img.shields.io/docker/pulls/masebb/ttsbot)

OSSのテキスト読み上げDiscordBot [TextToSpeakBot](https://github.com/Cosgy-Dev/TextToSpeakBot)を音声データのダウンロードなどの設定いらずでコンテナの上で動くようにしたDockerfileです(ベースイメージはUbuntu22.04)

最低限使えるようにすることが目標のため、[公式のセットアップ方法](https://www.cosgy.dev/2021/09/09/post-476/)に沿って音声データは[mmdagentプロジェクト](https://sourceforge.net/projects/mmdagent/)に内包されている`.htsvoice`ファイルを使用するようにしています。そのためこのDockerimageでのボイスの種類は`mei`、`takumi`、`slt`のみ使えます

## Usage
```bash
docker run -it masebb/ttsbot --name TTSBot --env token=<BOTTOKEN> --env owner=<USERID> --env prefix=<BOTCOMMANDPREFIX>
```
環境変数からconfigを生成します。基本的に環境変数名は[config.txt](https://github.com/Cosgy-Dev/TextToSpeakBot/releases/download/0.2.0-Beta.2/config.txt)の項目名と同じです。ですが、`status`はbashでは終了コードが代入されてしまうので変更する場合は代わりに`discordstatus`を使って変更してください(下に書いてあるdocker-compose.yamlを見るとよくわかります)

データーベース、ログ等の永続化をしたい場合はコンテナ内の`/TTSBot`に入っていますのでそれをホストの適当な場所に`-v`オプションでバインドしてください(注意 : config.txtが`/TTSBot`に入っている場合は環境変数からのコンフィグ生成を行いません)

### Docker-Composeを使用する場合
```yaml
version: '3'
services:
  TTSbot:
    image: masebb/ttsbot:latest
    environment:
      #必須
      - token=<Botトークン>
      - owner=<Bot管理者のユーザーID>
      #オプション
      # - prefix=<BOTのプレフィックス>(デフォルト: @<Bot名>)
      # - altprefix=<BOTのサブプレフィックス>(デフォルト: なし)
      # - game=<ゲームステータス名(〇〇をプレイ中)>(デフォルト: DEFAULT)
      # - status=<BOTステータス (ONLINE,IDLE,DND,INVISIBLEのみ)>(デフォルト: ONLINE)
      # - updatealeats=<真偽値(true or false)>(デフォルト: true)
      # - alonetimeuntilstop=<数字(秒)  >(デフォルト: 0(無効))
      # - maxmessagecount=<数字(文字数)  >(デフォルト: 0(disable))
      ### 基本的にはデフォルト値のままで良い(触る必要がない) ###
      # - dictionary=<DICTIONARY PATH>(デフォルト: /var/lib/mecab/dic/open-jtalk/naist-jdic)
      # - voiceDirectory=<VOICE DIRECTORY PATH>(デフォルト: /usr/share/hts-voice)
      ### 基本的にはデフォルト値のままで良い(触る必要がない) ###
    restart: always
    #ユーザデータの永続化をしたい場合コメントアウトしてください(./に散らかすので注意！)
    # volumes:
    #   - type: bind
    #     source: ./
    #     target: /TTSBot
```