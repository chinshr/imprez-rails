class Presentation < ActiveRecord::Base
  extend FriendlyId
  friendly_id :code
  
  CODE_LENGTH = 5
  
  attr_accessible :name, :body, :template

  validates :name, :presence => true
  validates :code, :presence => true, :uniqueness => true

  before_validation :create_code
  
  scope :template, where(template: true)
  
  private

  def create_code
    self.code ||= rand(36 ** CODE_LENGTH).to_s(36)
  end
  
end
