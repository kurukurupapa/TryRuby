@echo off
ruby -pne '$_.gsub!(/abc/,"ABC")' %1
