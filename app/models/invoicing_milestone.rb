class InvoicingMilestone < ActiveRecord::Base
  def unbilled
    invoiced_amount = InvoiceLine.where('invoicing_milestone_id = ?', self.id).sum(:amount)
    amount - invoiced_amount
  end

  def currency
    self.project.bu_currency
  end

  validates :name, presence: :true
  validates :amount, presence: :true
  validates :due_date, presence: :true
  validates :project_id, presence: :true

  belongs_to :project, class_name: 'Project', foreign_key: :project_id
end
