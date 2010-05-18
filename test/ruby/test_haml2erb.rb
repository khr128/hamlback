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

  def template_test name
   `#{@ha2er_exe} < #{File.join(@cur_dir, "haml/#{name}.html.haml")} > #{@output_file_name}`

    expected_file_name = File.join(@cur_dir, "expected/#{name}.html.erb")
    diff = `diff #{@output_file_name} #{expected_file_name}`
    assert_equal 0, $?.exitstatus, diff
    assert diff.empty?, diff
  end

  def test_simplest_tag
    template_test "simplest"
  end

  def test_simplest_tag_with_id
    template_test "simplest_with_id"
  end

  def test_simplest_tag_with_id_and_hash
    template_test "simplest_with_id_and_hash"
  end

  def test_simplest_tag_with_two_hashes
    template_test "simplest_with_two_hashes"
  end

  def test_one_level_nested_tags
    template_test "one_level_nested_tags"
  end

  def test_two_level_nested_tags
    template_test "two_level_nested_tags"
  end

  def test_simplest_div
    template_test "simplest_div"
  end

  def test_simplest_div_with_static_content
    template_test "simplest_div_with_static_content"
  end

  def test_simplest_div_with_ruby_content
    template_test "simplest_div_with_ruby_content"
  end

  def test_simplest_div_with_nested_ruby_content
    template_test "simplest_div_with_nested_ruby_content"
  end

  def test_simplest_div_with_nested_ruby_content_and_continuation
    template_test "simplest_div_with_nested_ruby_content_and_continuation"
  end

  def test_simplest_div_with_nested_ruby_code
    template_test "simplest_div_with_nested_ruby_code"
  end

  def test_simplest_div_with_comment
    template_test "simplest_div_with_comment"
  end

  def test_simplest_div_with_html_comment
    template_test "simplest_div_with_html_comment"
  end

  def test_simplest_div_with_plain_text
    template_test "simplest_div_with_plain_text"
  end

  def test_simplest_div_with_escaped_plain_text
    template_test "simplest_div_with_plain_text"
  end

  def test_ps_users_index
    template_test "ps_users/index"
  end

  def test_ps_users_new
    template_test "ps_users/new"
  end

  def test_ps_users_show
    template_test "ps_users/show"
  end

  def test_ps_users_edit
    template_test "ps_users/edit"
  end

  def test_ps_users__user
    template_test "ps_users/_user"
  end

  def test_ps_users_analyzer
    template_test "ps_layouts/analyzer"
  end

  def test_ps_ps_rhess_index
    template_test "ps_rhess/index"
  end

  def test_ps_ps_rhess__chessboard
    template_test "ps_rhess/_chessboard"
  end

  def test_ps_ps_rhess__available_pieces
    template_test "ps_rhess/_available_pieces"
  end

  def test_ps_ps_rhess__moves
    template_test "ps_rhess/_moves"
  end

  def test_ps_ps_rhess__rhess_game
    template_test "ps_rhess/_rhess_game"
  end

end
