class InvoiceStatus < ActiveRecord::Base
  default_scope {order('rank ASC')}

  validates :name, presence: :true, uniqueness: :true
  validates :rank, presence: :true
end
