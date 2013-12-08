while gets
	$_.gsub!(/abc/,"ABC")
	puts $_
end
