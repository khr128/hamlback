require 'test/unit'
class TestHaml2erb < Test::Unit::TestCase
  def setup
    @output_file_name = "test/output/parsed.html.erb"
  end

  def teardown
    File.delete(@output_file_name) if File.exists?(@output_file_name)
  end

  def test_simplest_tag
    File.open(@output_file_name, "w") do |out|
      out.puts `echo "%table" | cmake/ha2er`
    end

    expected_file_name = "test/expected/simplest.html.erb"
    diff = `diff #{@output_file_name} #{expected_file_name}`
    assert_equal 0, $?.exitstatus
    assert diff.empty?, diff
  end

  def test_simplest_tag_with_id
    File.open(@output_file_name, "w") do |out|
      out.puts `echo "%table#table_id" | cmake/ha2er`
    end

    expected_file_name = "test/expected/simplest_with_id.html.erb"
    diff = `diff #{@output_file_name} #{expected_file_name}`
    assert_equal 0, $?.exitstatus
    assert diff.empty?, diff
  end
end
