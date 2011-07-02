class Folder < ActiveRecord::Base
  acts_as_tree
  
  attr_accessible :name, :parent_id, :user_id
  
  belongs_to :user
  belongs_to :folder
  
  has_many :assets, :dependent => :destroy
end