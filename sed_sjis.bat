@echo off
ruby -Ks -pne '$_.gsub!(/��/,"����"); $_.gsub!(/�`/,"�`�i�`���_�j")' %1
