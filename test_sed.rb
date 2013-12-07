# Ruby�ŁAsed�R�}���h�̂悤�ɕ�����u�������Ă݂܂��B
#
# �Q�l�F
# ruby �������C�i�[�̎g�����܂Ƃ� - ����}�O�ŁI
#  http://takuya-1st.hatenablog.jp/entry/2013/08/19/194819

require 'fileutils'
require 'minitest/unit'
require 'pathname'


class TestSed < MiniTest::Unit::TestCase
	def setup
		@data_dir = Pathname.new("./data")
		@out_dir = Pathname.new("./result")
		@expect_dir = Pathname.new("./expect")
		
		FileUtils.mkdir_p(@out_dir)
	end
	
	# ���p�����̕ϊ�
	def test_ascii
		# ����
		in_file = @data_dir + "test_sed_ascii.txt"
		out_file = @out_dir + "test_sed_ascii.txt"
		expect_file = @expect_dir + "test_sed_ascii.txt"
		
		# �e�X�g���s
		system("sed_ascii.bat #{in_file} > #{out_file}")
		
		# ����
		assert_equal true, FileUtils.cmp(expect_file, out_file)
	end
	
	# ���p�L���̕ϊ�
	def test_ascii2
		# ����
		in_file = @data_dir + "test_sed_ascii.txt"
		out_file = @out_dir + "test_sed_ascii2.txt"
		expect_file = @expect_dir + "test_sed_ascii2.txt"
		
		# �e�X�g���s
		system("sed_ascii2.bat #{in_file} > #{out_file}")
		#puts File.read(out_file)
		
		# ����
		result = FileUtils.cmp(expect_file, out_file)
		assert_equal true, result
	end
	
	# ���{��iSJIS�j�̕ϊ�
	def test_sjis
		# ����
		in_file = @data_dir + "test_sed_sjis_crlf.txt"
		out_file = @out_dir + "test_sed_sjis_crlf.txt"
		expect_file = @expect_dir + "test_sed_sjis_crlf.txt"
		
		# �e�X�g���s
		system("sed_sjis.bat #{in_file} > #{out_file}")
		#puts File.read(out_file)
		
		# ����
		result = FileUtils.cmp(expect_file, out_file)
		assert_equal true, result
	end
	
	# ���{��iUTF-8�j�̕ϊ�
	def test_utf8
		# ����
		in_file = @data_dir + "test_sed_utf-8_lf.txt"
		out_file = @out_dir + "test_sed_utf-8_lf.txt"
		expect_file = @expect_dir + "test_sed_utf-8_lf.txt"
		
		# �e�X�g���s
		system("sed_utf8.bat #{in_file} > #{out_file}")
		#puts File.read(out_file)
		
		# ����
		result = FileUtils.cmp(expect_file, out_file)
		assert_equal true, result
	end
end


MiniTest::Unit.autorun
