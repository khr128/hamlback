namespace :test do
  desc "Run all tests from project directory"
  task :all do
    Dir.glob('test/test_*.rb').each do |file| 
      p "Running #{file}..."
      load file
    end
  end

  desc "Run all tests that match regex"
  task :grep, :file_regex, :test_regex do |t, args|
    p args.file_regex
    p args.test_regex
    Dir.glob('test/test_*.rb').each do |file| 
      if file =~ Regexp.new(args.file_regex)
        p "Running #{file}..."
        `ruby #{file} -n /#{args.test_regex}/`
      end
    end
  end
end

