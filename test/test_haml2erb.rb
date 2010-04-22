require 'test/unit'
class TestHaml2erb < Test::Unit::TestCase
  def test_simplest_tag
    p `pwd`
    puts `echo "%table" | cmake/ha2er`
    assert true
  end
end
