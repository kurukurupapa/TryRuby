# coding: Windows-31J

# �O��
# Ruby1.9�ȍ~
# 
# �Q�l
# ���s�R�[�hCR+LF�̃t�@�C������CR����菜�� - A Perfect Night For Bananafish
#  http://yocifico.hatenablog.com/entry/20081205/1228496554
# 
# �ŏ��ƍŌ�ŁA�����R�[�h��ϊ����Ă��܂��B
# �ϊ��㕶������o�͎��A���̓t�@�C���̉��s�R�[�h��ێ����邽�߁A$stdout��binmode���g���Ă��܂��B

while gets
	$_ = $_.force_encoding("UTF-8").encode("Windows-31J")
	$_.gsub!(/��/,"����")
	$_.gsub!(/�`/,"�`�i�`���_�j")
	$stdout.binmode.write($_.encode("UTF-8"))
end
