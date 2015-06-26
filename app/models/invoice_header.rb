class InvoiceHeader < ActiveRecord::Base
  validates :invoice_date, presence: :true
  validates :project_id, presence: :true
  validates :invoice_status_id, presence: :true
  validates :term_id, presence: :true

  belongs_to :project, :class_name => 'Project', :foreign_key => :project_id
  belongs_to :invoice_status, :class_name => 'InvoiceStatus', :foreign_key => :invoice_status_id
  belongs_to :term, :class_name => 'Term', :foreign_key => :term_id
end
