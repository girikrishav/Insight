class AssociateServiceRate < ActiveRecord::Base
  def bu_currency
    self.associate.bu_currency
  end

  def skill_designation
    self.service_rate.skill_designation
  end

  def skill_name
    Skill.find(self.service_rate.skill_id).name
  end

  def designation_name
    Designation.find(self.service_rate.designation_id).name
  end

  def populate_defaults
    self.billing_rate = ServiceRate.find(self.service_rate_id).billing_rate
    self.cost_rate = ServiceRate.find(self.service_rate_id).cost_rate
  end

  before_create :populate_defaults

  validates :associate, presence: true
  validates :service_rate, presence: true
  validates :as_on, presence: true

  validates_uniqueness_of :associate_id, scope: [:associate_id, :service_rate_id, :as_on]

  belongs_to :associate, :class_name => 'Associate', :foreign_key => :associate_id
  belongs_to :service_rate, :class_name => 'ServiceRate', :foreign_key => :service_rate_id
end
