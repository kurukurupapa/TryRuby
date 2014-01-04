# coding: Windows-31J

require 'fileutils'
require 'minitest/unit'
require 'pathname'

require './diffcopy'

MiniTest::Unit.autorun

# ------------------------------------------------------------
# テストクラス
# ------------------------------------------------------------
class TestBase < MiniTest::Unit::TestCase
	def setup
		@data_base_dir = Pathname.new("./data/test_diffcopy")
		@out_base_dir = Pathname.new("./result/test_diffcopy")
		@expect_base_dir = Pathname.new("./expect/test_diffcopy")
	end
end

class TestPathArray < TestBase
	# PathArrayクラスのコンストラクタ動作テスト
	# 対象ディレクトリにファイル/サブディレクトリを含まない場合
	def test_initialize_001
		# 準備
		indir = @data_base_dir + "Case001" + "Dir1"
		
		# テスト実行
		sut = PathArray.new(indir)
		
		# 検証
		expect = []
		assert_equal(indir, sut.dir)
		assert_equal(expect, sut)
	end
	
	# PathArrayクラスのコンストラクタのテスト
	# 対象ディレクトリにファイルのみを含む場合
	def test_initialize_002
		# 準備
		indir = @data_base_dir + "Case002" + "Dir1"
		
		# テスト実行
		sut = PathArray.new(indir)
		
		# 検証
		expect = ["DiffFile.txt", "Dir1OnlyFile.txt", "SameFile.txt"]
		assert_equal(expect, sut)
	end
	
	def test_initialize_two_args_001
		# 準備
		indir = @data_base_dir + "Case001" + "Dir1"
		
		# テスト実行
		sut = PathArray.new(indir, [])
		
		# 検証
		expect = []
		assert_instance_of(PathArray, sut)
		assert_equal(indir, sut.dir)
		assert_equal(expect, sut)
	end
	
	def test_initialize_two_args_002
		# 準備
		indir = @data_base_dir + "Case001" + "Dir1"
		
		# テスト実行
		sut = PathArray.new(indir, ["a", "b"])
		
		# 検証
		expect = ["a", "b"]
		assert_instance_of(PathArray, sut)
		assert_equal(indir, sut.dir)
		assert_equal(expect, sut)
	end
end

class TestDiffData < TestBase
	# DiffDataクラスのコンストラクタのテスト
	# ファイル/ディレクトリなしの場合
	def test_initialize_zero
		# 準備
		arr1 = PathArray.new(@data_base_dir + "Case001" + "Dir1")
		arr2 = PathArray.new(@data_base_dir + "Case001" + "Dir2")
		
		# テスト実行
		sut = DiffData.new(arr1, arr2)
		
		# 検証
		expect = []
		assert_instance_of(PathArray, sut.add_path_array)
		assert_instance_of(PathArray, sut.del_path_array)
		assert_instance_of(PathArray, sut.mod_path_array)
		assert_instance_of(PathArray, sut.update_path_array)
		assert_equal(expect, sut.add_path_array)
		assert_equal(expect, sut.del_path_array)
		assert_equal(expect, sut.mod_path_array)
		assert_equal(expect, sut.update_path_array)
	end
	
	# DiffDataクラスのコンストラクタのテスト
	# ファイル追加の場合
	def test_initialize_add_path_array
		# 準備
		arr1 = PathArray.new(@data_base_dir + "Case002" + "Dir1")
		arr2 = PathArray.new(@data_base_dir + "Case002" + "Dir2")
		
		# テスト実行
		sut = DiffData.new(arr1, arr2)
		
		# 検証
		expect = ["Dir2OnlyFile.txt"]
		assert_equal(expect, sut.add_path_array)
	end
	
	# DiffDataクラスのコンストラクタのテスト
	# ファイル削除の場合
	def test_initialize_del_path_array
		# 準備
		arr1 = PathArray.new(@data_base_dir + "Case002" + "Dir1")
		arr2 = PathArray.new(@data_base_dir + "Case002" + "Dir2")
		
		# テスト実行
		sut = DiffData.new(arr1, arr2)
		
		# 検証
		expect = ["Dir1OnlyFile.txt"]
		assert_equal(expect, sut.del_path_array)
	end
	
	# DiffDataクラスのコンストラクタのテスト
	# ファイル変更の場合
	def test_initialize_mod_path_array
		# 準備
		arr1 = PathArray.new(@data_base_dir + "Case002" + "Dir1")
		arr2 = PathArray.new(@data_base_dir + "Case002" + "Dir2")
		
		# テスト実行
		sut = DiffData.new(arr1, arr2)
		
		# 検証
		expect = ["DiffFile.txt"]
		assert_equal(expect, sut.mod_path_array)
	end
	
	# DiffDataクラスのコンストラクタのテスト
	# ファイル追加/変更/削除の場合のupdate_path_array
	def test_initialize_update_path_array
		# 準備
		arr1 = PathArray.new(@data_base_dir + "Case002" + "Dir1")
		arr2 = PathArray.new(@data_base_dir + "Case002" + "Dir2")
		
		# テスト実行
		sut = DiffData.new(arr1, arr2)
		
		# 検証
		expect = ["DiffFile.txt", "Dir2OnlyFile.txt"]
		assert_equal(expect, sut.update_path_array)
	end
end

class TestDiffCopy < TestBase
	# ファイル/フォルダなしの場合
	def test_zero
		# 準備
		in_dir1 = @data_base_dir + "Case001" + "Dir1"
		in_dir2 = @data_base_dir + "Case001" + "Dir2"
		out_dir = @out_base_dir + "Case001"
		expect_dir = @expect_base_dir + "Case001"
		sut = DiffCopy.new([in_dir1, in_dir2, out_dir])
		
		# テスト実行
		sut.run
		
		# 検証
		expect_files = Dir.chdir(expect_dir) { Dir.glob("**/*") }
		result_files = Dir.chdir(out_dir) { Dir.glob("**/*") }
		assert_equal(expect_files, result_files)
	end
	
	# ファイルあり/フォルダなしの場合
	def test_file_only
		# 準備
		in_dir1 = @data_base_dir + "Case002" + "Dir1"
		in_dir2 = @data_base_dir + "Case002" + "Dir2"
		out_dir = @out_base_dir + "Case002"
		expect_dir = @expect_base_dir + "Case002"
		sut = DiffCopy.new([in_dir1, in_dir2, out_dir])
		
		# テスト実行
		sut.run
		
		# 検証
		expect_files = Dir.chdir(expect_dir) { Dir.glob("**/*") }
		result_files = Dir.chdir(out_dir) { Dir.glob("**/*") }
		assert_equal(expect_files, result_files)
	end
	
	# ファイルあり/フォルダありの場合
	def test_file_dir
		# 準備
		in_dir1 = @data_base_dir + "Case003" + "Dir1"
		in_dir2 = @data_base_dir + "Case003" + "Dir2"
		out_dir = @out_base_dir + "Case003"
		expect_dir = @expect_base_dir + "Case003"
		sut = DiffCopy.new([in_dir1, in_dir2, out_dir])
		
		# テスト実行
		sut.run
		
		# 検証
		expect_files = Dir.chdir(expect_dir) { Dir.glob("**/*") }
		result_files = Dir.chdir(out_dir) { Dir.glob("**/*") }
		assert_equal(expect_files, result_files)
	end
end
