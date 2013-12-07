@echo off
ruby -Ks -pne '$_.gsub!(/朝/,"朝方"); $_.gsub!(/～/,"～（チルダ）")' %1
