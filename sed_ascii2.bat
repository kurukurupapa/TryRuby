@echo off
ruby -pne '$_.gsub!(/[!"#\\$%%\&()*+,-.\/:;<=>?@\[\]^_`{|}~]/,"")' -e "$_.gsub!(/'/,'')" %1
