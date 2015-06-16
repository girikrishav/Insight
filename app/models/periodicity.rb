class Periodicity < ActiveRecord::Base
  default_scope {order('rank ASC')}

  validates_uniqueness_of :name, scope: [:name]
  validates_uniqueness_of :rank, scope: [:rank]

  validates :name, presence: :true
  validates :rank, presence: :true
end
