# coding: Windows-31J

# 前提
# Ruby1.9以降

while gets
	$_.gsub!(/朝/,"朝方")
	$_.gsub!(/～/,"～（チルダ）")
	puts $_
end
