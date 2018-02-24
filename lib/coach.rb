require 'coach/version'
require 'thor'
require 'sequel'
require 'fileutils'
require 'tty-command'

module Coach
  class CLI < Thor
    no_commands do
      def db
        @db ||= Sequel.sqlite(File.join(Dir.home, '.config/coach/problems.sqlite3'))
      end
    end

    desc 'init', 'Initialize tracker database'
    def init
      path = File.join(Dir.home, '.config/coach/problems.sqlite3')

      return if File.exist?(path)

      FileUtils.mkdir_p(File.join(Dir.home, '.config/coach'))
      src = File.join(__dir__, 'coach/templates/problems.sqlite3')
      FileUtils.cp(src, path)
    end

    desc 'next', 'Next problem to do'
    method_option :level, aliases: '-l'
    method_option :category, aliases: '-c'
    def next
      categories = ['BEGINNER', 'DATA STRUCTURES',
                    'STRINGS', 'AD-HOC',
                    'PARADIGMS', 'MATHEMATICS',
                    'GEOMETRY', 'GRAPH']

      filters = { level: options[:level], status: 0,
                  category: options[:category] || categories.sample }.compact

      problem = db[:problems].where(filters).reverse(:solved).order(:level).first

      return unless problem

      puts "The problem #{problem[:id]}  is not done yet.\n" \
           "It is a problem in #{problem[:category]} with " \
           "difficult level #{problem[:level]} and was solved by #{problem[:solved]}"
    end

    desc 'update ID', 'Update your progress'
    method_option :status, aliases: '-s'
    def update(id)
      status = options[:status]
      code = { todo: 0, done: 1, skip: 1 }

      raise ArgumentError unless %w[skip done todo].include?(status)

      db[:problems].where(id: id).update(status: code[status.to_sym])
      puts "Problem #{id} is completed."
    end

    desc 'info ID', "Show a problem's status"
    def info(id)
      problem = db[:problems].first(id: id)

      case problem[:status]
      when 1
        puts "Problem #{id} was solved."
      when 2
        puts "Problem #{id} is out of the list " \
             "of undone problems but it's not solved."
      else
        puts "Problem #{id} has not been done yet. Let's try now."
      end
    end

    desc 'report', 'Summary of your progress'
    def report
      todo = db[:problems].where(status: 0).count
      done = db[:problems].where(status: 1).count
      skiped = db[:problems].where(status: 2).count

      puts "#{done} problems solved.\n" \
           "#{todo} problems unsolved.\n" \
           "#{skiped} problems skiped."
    end

    desc 'new PATH', 'Makes a new solution file from template'
    def new(dst)
      if File.exist?(dst)
        puts 'Files aready exist'
      else
        src = File.join(__dir__, 'coach/templates/c')
        FileUtils.cp(src, dst)
      end
    end

    desc 'test FILE', 'Test a solution against test cases'
    method_option :diff, aliases: '-d', type: :boolean, default: false
    method_option :log, aliases: '-l'
    def test(src_file)
      test = Test.new(src_file)
      test.run
    end
  end

  class Test
    def initialize(src_file)
      @test_dir = File.join(Dir.home, '.config/coach/cases')
      @temp_dir = Dir.home
      @src_file = src_file
      @cases = []
    end

    # Search for input and output files of test cases
    def cases
      return @cases unless @cases.empty?
      Dir.chdir(@test_dir) do
        Dir.glob("p#{File.basename(@src_file, '.*')}_c*.in").each do |f|
          input = File.join(Dir.pwd, "#{File.basename(f, '.*')}.in")
          output = File.join(Dir.pwd, "#{File.basename(f, '.*')}.out")
          @cases << [input, output] if File.exist?(input) && File.exist?(output)
        end
      end
      @cases
    end

    # Compile the source code
    def compile
      exe_file = File.join(@temp_dir, 'exe')
      result = TTY::Command.new(printer: :quiet).run!('gcc', '-o', exe_file, @src_file)
      [exe_file, result]
    end

    # Run solution against test cases
    def run
      exe_file, result = compile

      if result.failed?
        puts result.error
        return
      end

      if cases.empty?
        puts 'No test case found!'
        return
      end

      cmd = TTY::Command.new(printer: :progress)
      exe_output = File.join(@temp_dir, 'output')

      cases.each do |input, output|
        cmd.run!(exe_file, in: input, out: exe_output)
        identical = FileUtils.compare_file(output, exe_output)
        identical ? puts('Passed') : puts('Failed')
      end
    end
  end
end
