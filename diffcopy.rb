# coding: Windows-31J
# Ruby�ŁA��̃f�B���N�g���Ԃ̍������A�ʃf�B���N�g���փR�s�[���܂��B
#
# �Q�l
# Ruby�W���p�b�P�[�W�Ńf�B���N�g����r�������rsync���h�L������ - ����}�O�ŁI
# http://takuya-1st.hatenablog.jp/entry/20100921/1285054620

require 'fileutils'
require 'minitest/unit'
require 'pathname'
require 'pp'

# ------------------------------------------------------------
# DiffCopy�R�}���h�N���X
# ------------------------------------------------------------
class DiffCopy
	def initialize(argv)
		@args = Arguments.new(argv)
	end
	
	def run
		@args.parse
		if !@args.valid?
			@args.print_usage
			return
		end
		
		patharr1 = PathArray.new(@args.indir1)
		patharr2 = PathArray.new(@args.indir2)
		
		diffdata = DiffData.new(patharr1, patharr2)
		
		filecopy = FileCopy.new(diffdata.update_path_array, @args.outdir)
		filecopy.run
	end
end

# ------------------------------------------------------------
# �R�}���h���C�������N���X
# ------------------------------------------------------------
class Arguments
	attr_reader :indir1, :indir2, :outdir
	
	def initialize(argv)
		@argv = argv
	end
	
	def parse
		@indir1 = @argv[0]
		@indir2 = @argv[1]
		@outdir = @argv[2]
	end
	
	def valid?
		@indir1 && @indir2 && @outdir
	end
	
	def print_usage
		puts "Usage: diffcopy ���̓f�B���N�g��1 ���̓f�B���N�g��2 �o�̓f�B���N�g��"
	end
end

# ------------------------------------------------------------
# �p�X�z��N���X
# ------------------------------------------------------------
class PathArray < Array
	attr_reader :dir
	
	def initialize(dir, array = nil)
		@dir = dir
		if array == nil
			# �^����ꂽ�f�B���N�g���z���́A�t�@�C��/�f�B���N�g�����ċA�I�Ɏ擾����B
			Dir.chdir(dir) {
				concat(Dir.glob("**/*"))
			}
		else
			concat(array)
		end
	end
	
	# �ǉ��t�@�C��/�t�H���_���擾����B
	def add_path_array(other)
		PathArray.new(dir, self - other)
	end
	
	# �폜�t�@�C��/�t�H���_���擾����B
	def del_path_array(other)
		PathArray.new(other.dir, other - self)
	end
	
	# �ύX�t�@�C�����擾����B
	# ���t�H���_�̒��g�͕ʓr�m�F���邽�߁A�t�H���_�́A�ǉ�/�폜�̂݊m�F����B
	def mod_path_array(other)
		PathArray.new(dir, (self & other).delete_if {|e|
			pathname = Pathname.new(File.expand_path(e, self.dir))
			if pathname.directory?
				true
			elsif pathname.file?
				FileUtils.cmp(File.expand_path(e, self.dir), File.expand_path(e, other.dir))
			else
				$stderr.puts("�ΏۊO�p�X�F#{src}")
			end
		})
	end
end

# ------------------------------------------------------------
# �����N���X
# ------------------------------------------------------------
class DiffData
	attr_reader :add_path_array, :del_path_array, :mod_path_array
	
	def initialize(path_array1, path_array2)
		@add_path_array = path_array2.add_path_array(path_array1)
		@del_path_array = path_array2.del_path_array(path_array1)
		@mod_path_array = path_array2.mod_path_array(path_array1)
	end
	
	def update_path_array
		PathArray.new(@add_path_array.dir, (@add_path_array + @mod_path_array).sort)
	end
end

# ------------------------------------------------------------
# �t�@�C��/�f�B���N�g�������R�s�[�N���X
# ------------------------------------------------------------
class FileCopy
	def initialize(path_array, out_dir)
		@path_array = path_array
		@out_dir = out_dir
	end
	
	def run
		@path_array.each {|e|
			src = Pathname.new(File.expand_path(e, @path_array.dir))
			dest = Pathname.new(File.expand_path(e, @out_dir))
			if src.directory?
				FileUtils.mkdir_p(dest, {:verbose => $VERBOSE})
			elsif src.file?
				FileUtils.mkdir_p(dest.parent, {:verbose => $VERBOSE})
				FileUtils.cp(src, dest, {:verbose => $VERBOSE})
			else
				$stderr.puts("�ΏۊO�p�X�F#{src}")
			end
		}
	end
end

# ------------------------------------------------------------
# �R�}���h���s
# ------------------------------------------------------------
if __FILE__ == $0
	main = DiffCopy.new(ARGV)
	main.run
end
