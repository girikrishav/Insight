class InvoicingMilestone < ActiveRecord::Base
  validates :name, presence: :true
  validates :amount, presence: :true
  validates :due_date, presence: :true
  validates :project_id, presence: :true

  belongs_to :project, class_name: 'Project', foreign_key: :project_id
end
