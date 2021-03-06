# coding: Windows-31J
# Rubyで、二つのディレクトリ間の差分を、別ディレクトリへコピーします。
#
# 参考
# Ruby標準パッケージでディレクトリ比較を作ってrsyncモドキをする - それマグで！
# http://takuya-1st.hatenablog.jp/entry/20100921/1285054620

require 'fileutils'
require 'pathname'

# ------------------------------------------------------------
# DiffCopyコマンドクラス
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
# コマンドライン引数クラス
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
		puts "Usage: diffcopy 変更前ディレクトリ 変更後ディレクトリ 出力ディレクトリ"
	end
end

# ------------------------------------------------------------
# パス配列クラス
# ------------------------------------------------------------
class PathArray < Array
	attr_reader :dir
	
	def initialize(dir, array = nil)
		@dir = dir
		if array == nil
			# 与えられたディレクトリ配下の、ファイル/ディレクトリを再帰的に取得する。
			Dir.chdir(dir) {
				concat(Dir.glob("**/*"))
			}
		else
			concat(array)
		end
	end
	
	# 追加ファイル/フォルダを取得する。
	def add_path_array(other)
		PathArray.new(dir, self - other)
	end
	
	# 削除ファイル/フォルダを取得する。
	def del_path_array(other)
		PathArray.new(other.dir, other - self)
	end
	
	# 変更ファイルを取得する。
	# ※フォルダの中身は別途確認するため、フォルダは、追加/削除のみ確認する。
	def mod_path_array(other)
		PathArray.new(dir, (self & other).delete_if {|e|
			pathname = Pathname.new(File.expand_path(e, self.dir))
			if pathname.directory?
				true
			elsif pathname.file?
				FileUtils.cmp(File.expand_path(e, self.dir), File.expand_path(e, other.dir))
			else
				$stderr.puts("対象外パス：#{src}")
			end
		})
	end
end

# ------------------------------------------------------------
# 差分クラス
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
# ファイル/ディレクトリ差分コピークラス
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
				$stderr.puts("対象外パス：#{src}")
			end
		}
	end
end

# ------------------------------------------------------------
# コマンド実行
# ------------------------------------------------------------
if __FILE__ == $0
	main = DiffCopy.new(ARGV)
	main.run
end
