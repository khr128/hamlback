require 'test/unit'
class TestHaml2erb < Test::Unit::TestCase
  def setup
    @cur_dir = File.dirname(__FILE__)
    @output_file_name = File.join(@cur_dir, "erb/parsed.html.erb")
    @ha2er_exe = File.join(@cur_dir, "..", "..",  "cmake", "src", "ha2er")
  end

  def teardown
#    File.delete(@output_file_name) if File.exists?(@output_file_name)
  end

  def test_simplest_tag
   `#{@ha2er_exe} < #{File.join(@cur_dir, "haml/simplest.html.haml")} > #{@output_file_name}`

    expected_file_name = File.join(@cur_dir, "expected/simplest.html.erb")
    diff = `diff #{@output_file_name} #{expected_file_name}`
    assert_equal 0, $?.exitstatus, diff
    assert diff.empty?, diff
  end

  def test_simplest_tag_with_id
    `#{@ha2er_exe} < #{File.join(@cur_dir, "haml/simplest_with_id.html.haml")} > #{@output_file_name}`

    expected_file_name = File.join(@cur_dir, "expected/simplest_with_id.html.erb")
    diff = `diff #{@output_file_name} #{expected_file_name}`
    assert_equal 0, $?.exitstatus, diff
    assert diff.empty?, diff
  end

  def test_simplest_tag_with_id_and_hash
    `#{@ha2er_exe} < #{File.join(@cur_dir, "haml/simplest_with_id_and_hash.html.haml")} > #{@output_file_name}`

    expected_file_name = File.join(@cur_dir, "expected/simplest_with_id_and_hash.html.erb")
    diff = `diff #{@output_file_name} #{expected_file_name}`
    assert_equal 0, $?.exitstatus, diff
    assert diff.empty?, diff
  end

  def test_one_level_nested_tags
    `#{@ha2er_exe} < #{File.join(@cur_dir, "haml/one_level_nested_tags.html.haml")} > #{@output_file_name}`

    expected_file_name = File.join(@cur_dir, "expected/one_level_nested_tags.html.erb")
    diff = `diff #{@output_file_name} #{expected_file_name}`
    assert_equal 0, $?.exitstatus, diff
    assert diff.empty?, diff
  end

  def test_two_level_nested_tags
    `#{@ha2er_exe} < #{File.join(@cur_dir, "haml/two_level_nested_tags.html.haml")} > #{@output_file_name}`

    expected_file_name = File.join(@cur_dir, "expected/two_level_nested_tags.html.erb")
    diff = `diff #{@output_file_name} #{expected_file_name}`
    assert_equal 0, $?.exitstatus, diff
    assert diff.empty?, diff
  end

  def test_simplest_div
   `#{@ha2er_exe} < #{File.join(@cur_dir, "haml/simplest_div.html.haml")} > #{@output_file_name}`

    expected_file_name = File.join(@cur_dir, "expected/simplest_div.html.erb")
    diff = `diff #{@output_file_name} #{expected_file_name}`
    assert_equal 0, $?.exitstatus, diff
    assert diff.empty?, diff
  end

  def test_simplest_div_with_static_content
   `#{@ha2er_exe} < #{File.join(@cur_dir, "haml/simplest_div_with_static_content.html.haml")} > #{@output_file_name}`

    expected_file_name = File.join(@cur_dir, "expected/simplest_div_with_static_content.html.erb")
    diff = `diff #{@output_file_name} #{expected_file_name}`
    assert_equal 0, $?.exitstatus, diff
    assert diff.empty?, diff
  end

  def test_simplest_div_with_ruby_content
   `#{@ha2er_exe} < #{File.join(@cur_dir, "haml/simplest_div_with_ruby_content.html.haml")} > #{@output_file_name}`

    expected_file_name = File.join(@cur_dir, "expected/simplest_div_with_ruby_content.html.erb")
    diff = `diff #{@output_file_name} #{expected_file_name}`
    assert_equal 0, $?.exitstatus, diff
    assert diff.empty?, diff
  end

  def test_simplest_div_with_nested_ruby_content
   `#{@ha2er_exe} < #{File.join(@cur_dir, "haml/simplest_div_with_nested_ruby_content.html.haml")} > #{@output_file_name}`

    expected_file_name = File.join(@cur_dir, "expected/simplest_div_with_nested_ruby_content.html.erb")
    diff = `diff #{@output_file_name} #{expected_file_name}`
    assert_equal 0, $?.exitstatus, diff
    assert diff.empty?, diff
  end

  def test_simplest_div_with_nested_ruby_content_and_continuation
   `#{@ha2er_exe} < #{File.join(@cur_dir, "haml/simplest_div_with_nested_ruby_content_and_continuation.html.haml")} > #{@output_file_name}`

    expected_file_name = File.join(@cur_dir, "expected/simplest_div_with_nested_ruby_content_and_continuation.html.erb")
    diff = `diff #{@output_file_name} #{expected_file_name}`
    assert_equal 0, $?.exitstatus, diff
    assert diff.empty?, diff
  end

  def test_simplest_div_with_nested_ruby_code
   `#{@ha2er_exe} < #{File.join(@cur_dir, "haml/simplest_div_with_nested_ruby_code.html.haml")} > #{@output_file_name}`

    expected_file_name = File.join(@cur_dir, "expected/simplest_div_with_nested_ruby_code.html.erb")
    diff = `diff #{@output_file_name} #{expected_file_name}`
    assert_equal 0, $?.exitstatus, diff
    assert diff.empty?, diff
  end

  def test_simplest_div_with_comment
   `#{@ha2er_exe} < #{File.join(@cur_dir, "haml/simplest_div_with_comment.html.haml")} > #{@output_file_name}`

    expected_file_name = File.join(@cur_dir, "expected/simplest_div_with_comment.html.erb")
    diff = `diff #{@output_file_name} #{expected_file_name}`
    assert_equal 0, $?.exitstatus, diff
    assert diff.empty?, diff
  end

end
