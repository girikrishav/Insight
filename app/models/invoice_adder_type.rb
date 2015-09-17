class InvoiceAdderType < ActiveRecord::Base
  default_scope {order('rank ASC')}

  validates_uniqueness_of :name, scope: [:name, :applicable_date]

  validates :name, presence: :true
  validates :rank, presence: :true
  validates :applicable_date, presence: :true
  validates :rate_applicable, presence: :true
end
