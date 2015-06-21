class Overhead < ActiveRecord::Base
  def bu_currency
    Currency.find(BusinessUnit.find(self.business_unit_id).currency_id).name
  end

  def date_check
    if self.from_date > self.to_date
      errors.add(:from_date, I18n.t('errors.from_after_to_date'))
      errors.add(:to_date, I18n.t('errors.to_before_from_date'))
    end
  end

  validate :date_check

  validates :business_unit, presence: :true
  validates :cost_adder_type, presence: :true
  validates :from_date, presence: :true
  validates :periodicity, presence: :true
  validates :to_date, presence: :true
  validates :amount, presence: :true

  validates_uniqueness_of :business_unit_id, scope: [:business_unit_id, :cost_adder_type_id, :from_date, :to_date]
  validates_uniqueness_of :cost_adder_type_id, scope: [:business_unit_id, :cost_adder_type_id, :from_date, :to_date]
  validates_uniqueness_of :from_date, scope: [:business_unit_id, :cost_adder_type_id, :from_date, :to_date]
  validates_uniqueness_of :to_date, scope: [:business_unit_id, :cost_adder_type_id, :from_date, :to_date]

  belongs_to :business_unit, :class_name => 'BusinessUnit', :foreign_key => :business_unit_id
  belongs_to :cost_adder_type, :class_name => 'CostAdderType', :foreign_key => :cost_adder_type_id
  belongs_to :periodicity, :class_name => 'Periodicity', :foreign_key => :periodicity_id
end
