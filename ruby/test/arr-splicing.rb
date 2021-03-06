#!/usr/bin/ruby

  ####################################################################
  # A FileList is essentially an array with a few helper methods
  # defined to make file manipulation a bit easier.
  #
  class FileList < Array

    # Rewrite all array methods (and to_s/inspect) to resolve the list
    # before running.
    method_list = Array.instance_methods - Object.instance_methods
    %w[to_a to_s inspect].each do |meth|
      method_list << meth unless method_list.include? meth
    end
    method_list.each_with_index do |sym, i|
      if sym =~ /^[A-Za-z_]+$/
	name = sym
      else
	name = i
      end
      alias_method "array_#{name}", sym
      class_eval %{
        def #{sym}(*args, &block)
          resolve if @pending
	  array_#{name}(*args, &block)
	end
      }
    end

    # Create a file list from the globbable patterns given.  If you
    # wish to perform multiple includes or excludes at object build
    # time, use the "yield self" pattern.
    #
    # Example:
    #   file_list = FileList.new['lib/**/*.rb', 'test/test*.rb']
    #
    #   pkg_files = FileList.new['lib/**/*'] do |fl|
    #     fl.exclude(/\bCVS\b/)
    #   end
    #
    def initialize(*patterns)
      @pending_add = []
      @pending = false
      @exclude_patterns = DEFAULT_IGNORE_PATTERNS.dup
      @exclude_re = nil
      patterns.each { |pattern| include(pattern) }
      yield self if block_given?
    end

    # Add file names defined by glob patterns to the file list.  If an
    # array is given, add each element of the array.
    #
    # Example:
    #   file_list.include("*.java", "*.cfg")
    #   file_list.include %w( math.c lib.h *.o )
    #
    def include(*filenames)
      # TODO: check for pending
      filenames.each do |fn| @pending_add << fn end
      @pending = true
      self
    end
    alias :add :include 
    
    # Register a list of file name patterns that should be excluded
    # from the list.  Patterns may be regular expressions, glob
    # patterns or regular strings.
    #
    # Note that glob patterns are expanded against the file system.
    # If a file is explicitly added to a file list, but does not exist
    # in the file system, then an glob pattern in the exclude list
    # will not exclude the file.
    #
    # Examples:
    #   FileList['a.c', 'b.c'].exclude("a.c") => ['b.c']
    #   FileList['a.c', 'b.c'].exclude(/^a/)  => ['b.c']
    #
    # If "a.c" is a file, then ...
    #   FileList['a.c', 'b.c'].exclude("a.*") => ['b.c']
    #
    # If "a.c" is not a file, then ...
    #   FileList['a.c', 'b.c'].exclude("a.*") => ['a.c', 'b.c']
    #
    def exclude(*patterns)
      # TODO: check for pending
      patterns.each do |pat| @exclude_patterns << pat end
      if ! @pending
	calculate_exclude_regexp
	reject! { |fn| fn =~ @exclude_re }
      end
      self
    end

    
    def clear_exclude
      @exclude_patterns = []
      calculate_exclude_regexp if ! @pending
    end

    # Resolve all the pending adds now.
    def resolve
      @pending = false
      @pending_add.each do |fn| resolve_add(fn) end
      @pending_add = []
      resolve_exclude
      self
    end

    def calculate_exclude_regexp
      ignores = []
      @exclude_patterns.each do |pat|
	case pat
	when Regexp
	  ignores << pat
	when /[*.]/
	  Dir[pat].each do |p| ignores << p end
	else
	  ignores << Regexp.quote(pat)
	end
      end
      if ignores.empty?
	@exclude_re = /^$/
      else
	re_str = ignores.collect { |p| "(" + p.to_s + ")" }.join("|")
	@exclude_re = Regexp.new(re_str)
      end
    end

    def resolve_add(fn)
      case fn
      when Array
	fn.each { |f| self.resolve_add(f) }
      when %r{[*?]}
	add_matching(fn)
      else
	self << fn
      end
    end

    def resolve_exclude
      @exclude_patterns.each do |pat|
	case pat
	when Regexp
	  reject! { |fn| fn =~ pat }
	when /[*.]/
	  reject_list = Dir[pat]
	  reject! { |fn| reject_list.include?(fn) }
	else
	  reject! { |fn| fn == pat }
	end
      end
      self
    end

    # Return a new FileList with the results of running +sub+ against
    # each element of the oringal list.
    #
    # Example:
    #   FileList['a.c', 'b.c'].sub(/\.c$/, '.o')  => ['a.o', 'b.o']
    #
    def sub(pat, rep)
      inject(FileList.new) { |res, fn| res << fn.sub(pat,rep) }
    end

    # Return a new FileList with the results of running +gsub+ against
    # each element of the original list.
    #
    # Example:
    #   FileList['lib/test/file', 'x/y'].gsub(/\//, "\\")
    #      => ['lib\\test\\file', 'x\\y']
    #
    def gsub(pat, rep)
      inject(FileList.new) { |res, fn| res << fn.gsub(pat,rep) }
    end

    # Same as +sub+ except that the oringal file list is modified.
    def sub!(pat, rep)
      each_with_index { |fn, i| self[i] = fn.sub(pat,rep) }
      self
    end

    # Same as +gsub+ except that the original file list is modified.
    def gsub!(pat, rep)
      each_with_index { |fn, i| self[i] = fn.gsub(pat,rep) }
      self
    end

    # Convert a FileList to a string by joining all elements with a space.
    def to_s
      resolve if @pending
      self.join(' ')
    end

    # Add matching glob patterns.
    def add_matching(pattern)
      Dir[pattern].each do |fn|
	self << fn unless exclude?(fn)
      end
    end
    private :add_matching

    # Should the given file name be excluded?
    def exclude?(fn)
      calculate_exclude_regexp unless @exclude_re
      fn =~ @exclude_re
    end

    DEFAULT_IGNORE_PATTERNS = [
      /(^|[\/\\])CVS([\/\\]|$)/,
      /\.bak$/,
      /~$/,
      /(^|[\/\\])core$/
    ]
    @exclude_patterns = DEFAULT_IGNORE_PATTERNS.dup

    class << self
      # Create a new file list including the files listed. Similar to:
      #
      #   FileList.new(*args)
      def [](*args)
	new(*args)
      end

      # Set the ignore patterns back to the default value.  The
      # default patterns will ignore files 
      # * containing "CVS" in the file path
      # * ending with ".bak"
      # * ending with "~"
      # * named "core"
      #
      # Note that file names beginning with "." are automatically
      # ignored by Ruby's glob patterns and are not specifically
      # listed in the ignore patterns.
      def select_default_ignore_patterns
	@exclude_patterns = DEFAULT_IGNORE_PATTERNS.dup
      end

      # Clear the ignore patterns.  
      def clear_ignore_patterns
	@exclude_patterns = [ /^$/ ]
      end
    end
  end


puts ['.intin.rb', *FileList.new("./**/*.rb")].inspect
