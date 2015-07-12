class InvoiceHeader < ActiveRecord::Base
  def compute_due_date
    self.due_date = self.invoice_date + Term.find(self.term_id).days
  end

  def name
    self.id.to_s + ' [' + self.invoice_date.to_s + '] [' + sprintf('%.2f', self.amount) \
      + '], ' + self.project.name
    # 'Invoice = ' + self.id.to_s + ' [' + self.invoice_date.to_s + \
    #   '] [' + self.project.bu_currency + '] [' + sprintf('%.2f', self.amount) \
    #   + '], ' + self.project.name
  end

  def amount
    amount = 0
    amount += InvoiceAdder.where(invoice_header_id: self.id).sum(:amount)
    amount += InvoiceLine.where(invoice_header_id: self.id).sum(:amount)
  end

  def bu_currency
    Currency.find(self.project.id)
  end

  def unpaid
    paid_amount = PaymentLine.where('invoice_header_id = ?', self.id).sum(:amount)
    amount - paid_amount
  end

  before_create :compute_due_date
  before_update :compute_due_date


  validates :description, presence: :true
  validates :invoice_date, presence: :true
  validates :project_id, presence: :true
  validates :invoice_status_id, presence: :true
  validates :term_id, presence: :true

  belongs_to :project, :class_name => 'Project', :foreign_key => :project_id
  belongs_to :invoice_status, :class_name => 'InvoiceStatus', :foreign_key => :invoice_status_id
  belongs_to :term, :class_name => 'Term', :foreign_key => :term_id
end
