while gets
	$_.gsub!(/[!"#\$%&'()*+,-.\/:;<=>?@\[\\\]^_`{|}~]/,"")
	puts $_
end
