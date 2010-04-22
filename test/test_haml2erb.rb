require 'test/unit'
class TestHaml2erb < Test::Unit::TestCase
  def setup
    @output_file_name = "test/erb/parsed.html.erb"
  end

  def teardown
    File.delete(@output_file_name) if File.exists?(@output_file_name)
  end

  def test_simplest_tag
   `cmake/ha2er < test/haml/simplest.html.haml > #{@output_file_name}`

    expected_file_name = "test/expected/simplest.html.erb"
    diff = `diff #{@output_file_name} #{expected_file_name}`
    assert_equal 0, $?.exitstatus, diff
    assert diff.empty?, diff
  end

  def test_simplest_tag_with_id
    `cmake/ha2er < test/haml/simplest_with_id.html.haml > #{@output_file_name}`

    expected_file_name = "test/expected/simplest_with_id.html.erb"
    diff = `diff #{@output_file_name} #{expected_file_name}`
    assert_equal 0, $?.exitstatus, diff
    assert diff.empty?, diff
  end
end
