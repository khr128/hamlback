namespace :test do
  desc "Run all tests from project directory"
  task :all do
    Dir.glob('test/test_*.rb').each do |file| 
      p "Running #{file}..."
      load file
    end
  end
end

