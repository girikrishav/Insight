class Term < ActiveRecord::Base
  validates :name, presence: :true, uniqueness: :true
  validates :days, presence: :true
end
