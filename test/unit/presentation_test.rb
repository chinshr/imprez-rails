require 'test_helper'

class PresentationTest < ActiveSupport::TestCase
  should validate_presence_of :name
  #should validate_presence_of :code
  
  should "find template in scope" do
    assert_equal presentations(:simple_template), Presentation.template.first
  end
  
  should "create code" do
    prez = Presentation.create(name: "Wow Presentation!", body: "<div></div>")
    assert prez.code.length > 0
  end
  
end
