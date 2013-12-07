# Rubyで、sedコマンドのように文字列置換をしてみます。
#
# 参考：
# ruby ワンライナーの使い方まとめ - それマグで！
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
	
	# 半角文字の変換
	def test_ascii
		# 準備
		in_file = @data_dir + "test_sed_ascii.txt"
		out_file = @out_dir + "test_sed_ascii.txt"
		expect_file = @expect_dir + "test_sed_ascii.txt"
		
		# テスト実行
		system("sed_ascii.bat #{in_file} > #{out_file}")
		
		# 検証
		assert_equal true, FileUtils.cmp(expect_file, out_file)
	end
	
	# 半角記号の変換
	def test_ascii2
		# 準備
		in_file = @data_dir + "test_sed_ascii.txt"
		out_file = @out_dir + "test_sed_ascii2.txt"
		expect_file = @expect_dir + "test_sed_ascii2.txt"
		
		# テスト実行
		system("sed_ascii2.bat #{in_file} > #{out_file}")
		#puts File.read(out_file)
		
		# 検証
		result = FileUtils.cmp(expect_file, out_file)
		assert_equal true, result
	end
	
	# 日本語（SJIS）の変換
	def test_sjis
		# 準備
		in_file = @data_dir + "test_sed_sjis_crlf.txt"
		out_file = @out_dir + "test_sed_sjis_crlf.txt"
		expect_file = @expect_dir + "test_sed_sjis_crlf.txt"
		
		# テスト実行
		system("sed_sjis.bat #{in_file} > #{out_file}")
		#puts File.read(out_file)
		
		# 検証
		result = FileUtils.cmp(expect_file, out_file)
		assert_equal true, result
	end
	
	# 日本語（UTF-8）の変換
	def test_utf8
		# 準備
		in_file = @data_dir + "test_sed_utf-8_lf.txt"
		out_file = @out_dir + "test_sed_utf-8_lf.txt"
		expect_file = @expect_dir + "test_sed_utf-8_lf.txt"
		
		# テスト実行
		system("sed_utf8.bat #{in_file} > #{out_file}")
		#puts File.read(out_file)
		
		# 検証
		result = FileUtils.cmp(expect_file, out_file)
		assert_equal true, result
	end
end


MiniTest::Unit.autorun
