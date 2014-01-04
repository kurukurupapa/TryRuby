# coding: Windows-31J

require 'fileutils'
require 'minitest/unit'
require 'pathname'

require './diffcopy'

MiniTest::Unit.autorun

# ------------------------------------------------------------
# �e�X�g�N���X
# ------------------------------------------------------------
class TestBase < MiniTest::Unit::TestCase
	def setup
		@data_base_dir = Pathname.new("./data/test_diffcopy")
		@out_base_dir = Pathname.new("./result/test_diffcopy")
		@expect_base_dir = Pathname.new("./expect/test_diffcopy")
	end
end

class TestPathArray < TestBase
	# PathArray�N���X�̃R���X�g���N�^����e�X�g
	# �Ώۃf�B���N�g���Ƀt�@�C��/�T�u�f�B���N�g�����܂܂Ȃ��ꍇ
	def test_initialize_001
		# ����
		indir = @data_base_dir + "Case001" + "Dir1"
		
		# �e�X�g���s
		sut = PathArray.new(indir)
		
		# ����
		expect = []
		assert_equal(indir, sut.dir)
		assert_equal(expect, sut)
	end
	
	# PathArray�N���X�̃R���X�g���N�^�̃e�X�g
	# �Ώۃf�B���N�g���Ƀt�@�C���݂̂��܂ޏꍇ
	def test_initialize_002
		# ����
		indir = @data_base_dir + "Case002" + "Dir1"
		
		# �e�X�g���s
		sut = PathArray.new(indir)
		
		# ����
		expect = ["DiffFile.txt", "Dir1OnlyFile.txt", "SameFile.txt"]
		assert_equal(expect, sut)
	end
	
	def test_initialize_two_args_001
		# ����
		indir = @data_base_dir + "Case001" + "Dir1"
		
		# �e�X�g���s
		sut = PathArray.new(indir, [])
		
		# ����
		expect = []
		assert_instance_of(PathArray, sut)
		assert_equal(indir, sut.dir)
		assert_equal(expect, sut)
	end
	
	def test_initialize_two_args_002
		# ����
		indir = @data_base_dir + "Case001" + "Dir1"
		
		# �e�X�g���s
		sut = PathArray.new(indir, ["a", "b"])
		
		# ����
		expect = ["a", "b"]
		assert_instance_of(PathArray, sut)
		assert_equal(indir, sut.dir)
		assert_equal(expect, sut)
	end
end

class TestDiffData < TestBase
	# DiffData�N���X�̃R���X�g���N�^�̃e�X�g
	# �t�@�C��/�f�B���N�g���Ȃ��̏ꍇ
	def test_initialize_zero
		# ����
		arr1 = PathArray.new(@data_base_dir + "Case001" + "Dir1")
		arr2 = PathArray.new(@data_base_dir + "Case001" + "Dir2")
		
		# �e�X�g���s
		sut = DiffData.new(arr1, arr2)
		
		# ����
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
	
	# DiffData�N���X�̃R���X�g���N�^�̃e�X�g
	# �t�@�C���ǉ��̏ꍇ
	def test_initialize_add_path_array
		# ����
		arr1 = PathArray.new(@data_base_dir + "Case002" + "Dir1")
		arr2 = PathArray.new(@data_base_dir + "Case002" + "Dir2")
		
		# �e�X�g���s
		sut = DiffData.new(arr1, arr2)
		
		# ����
		expect = ["Dir2OnlyFile.txt"]
		assert_equal(expect, sut.add_path_array)
	end
	
	# DiffData�N���X�̃R���X�g���N�^�̃e�X�g
	# �t�@�C���폜�̏ꍇ
	def test_initialize_del_path_array
		# ����
		arr1 = PathArray.new(@data_base_dir + "Case002" + "Dir1")
		arr2 = PathArray.new(@data_base_dir + "Case002" + "Dir2")
		
		# �e�X�g���s
		sut = DiffData.new(arr1, arr2)
		
		# ����
		expect = ["Dir1OnlyFile.txt"]
		assert_equal(expect, sut.del_path_array)
	end
	
	# DiffData�N���X�̃R���X�g���N�^�̃e�X�g
	# �t�@�C���ύX�̏ꍇ
	def test_initialize_mod_path_array
		# ����
		arr1 = PathArray.new(@data_base_dir + "Case002" + "Dir1")
		arr2 = PathArray.new(@data_base_dir + "Case002" + "Dir2")
		
		# �e�X�g���s
		sut = DiffData.new(arr1, arr2)
		
		# ����
		expect = ["DiffFile.txt"]
		assert_equal(expect, sut.mod_path_array)
	end
	
	# DiffData�N���X�̃R���X�g���N�^�̃e�X�g
	# �t�@�C���ǉ�/�ύX/�폜�̏ꍇ��update_path_array
	def test_initialize_update_path_array
		# ����
		arr1 = PathArray.new(@data_base_dir + "Case002" + "Dir1")
		arr2 = PathArray.new(@data_base_dir + "Case002" + "Dir2")
		
		# �e�X�g���s
		sut = DiffData.new(arr1, arr2)
		
		# ����
		expect = ["DiffFile.txt", "Dir2OnlyFile.txt"]
		assert_equal(expect, sut.update_path_array)
	end
end

class TestDiffCopy < TestBase
	# �t�@�C��/�t�H���_�Ȃ��̏ꍇ
	def test_zero
		# ����
		in_dir1 = @data_base_dir + "Case001" + "Dir1"
		in_dir2 = @data_base_dir + "Case001" + "Dir2"
		out_dir = @out_base_dir + "Case001"
		expect_dir = @expect_base_dir + "Case001"
		sut = DiffCopy.new([in_dir1, in_dir2, out_dir])
		
		# �e�X�g���s
		sut.run
		
		# ����
		expect_files = Dir.chdir(expect_dir) { Dir.glob("**/*") }
		result_files = Dir.chdir(out_dir) { Dir.glob("**/*") }
		assert_equal(expect_files, result_files)
	end
	
	# �t�@�C������/�t�H���_�Ȃ��̏ꍇ
	def test_file_only
		# ����
		in_dir1 = @data_base_dir + "Case002" + "Dir1"
		in_dir2 = @data_base_dir + "Case002" + "Dir2"
		out_dir = @out_base_dir + "Case002"
		expect_dir = @expect_base_dir + "Case002"
		sut = DiffCopy.new([in_dir1, in_dir2, out_dir])
		
		# �e�X�g���s
		sut.run
		
		# ����
		expect_files = Dir.chdir(expect_dir) { Dir.glob("**/*") }
		result_files = Dir.chdir(out_dir) { Dir.glob("**/*") }
		assert_equal(expect_files, result_files)
	end
	
	# �t�@�C������/�t�H���_����̏ꍇ
	def test_file_dir
		# ����
		in_dir1 = @data_base_dir + "Case003" + "Dir1"
		in_dir2 = @data_base_dir + "Case003" + "Dir2"
		out_dir = @out_base_dir + "Case003"
		expect_dir = @expect_base_dir + "Case003"
		sut = DiffCopy.new([in_dir1, in_dir2, out_dir])
		
		# �e�X�g���s
		sut.run
		
		# ����
		expect_files = Dir.chdir(expect_dir) { Dir.glob("**/*") }
		result_files = Dir.chdir(out_dir) { Dir.glob("**/*") }
		assert_equal(expect_files, result_files)
	end
end
