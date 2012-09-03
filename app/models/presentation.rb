class Presentation < ActiveRecord::Base
  attr_accessible :content, :template
  
  scope :template, where(template: true)
end
