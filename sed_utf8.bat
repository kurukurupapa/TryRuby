@echo off

rem 前提
rem Ruby1.9以降
rem 
rem 参考
rem 改行コードCR+LFのファイルからCRを取り除く - A Perfect Night For Bananafish
rem  http://yocifico.hatenablog.com/entry/20081205/1228496554
rem 
rem 最初と最後で、文字コードを変換しています。
rem 変換後文字列を出力時、入力ファイルの改行コードを保持するため、$stdoutのbinmodeを使っています。

ruby -Ks -ne '$_ = $_.force_encoding("UTF-8").encode("Windows-31J"); $_.gsub!(/朝/,"朝方"); $_.gsub!(/～/,"～（チルダ）"); $stdout.binmode.write($_.encode("UTF-8"))' %1
