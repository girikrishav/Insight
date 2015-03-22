class Overhead < ActiveRecord::Base
  def bu_currency
    Currency.find(BusinessUnit.find(self.business_unit_id).currency_id).name
  end

  validates :business_unit, presence: :true
  validates :cost_adder_type, presence: :true
  validates :as_on, presence: :true
  validates :amount, presence: :true

  validates_uniqueness_of :business_unit_id, scope: [:business_unit_id, :cost_adder_type_id, :as_on]
  validates_uniqueness_of :cost_adder_type_id, scope: [:business_unit_id, :cost_adder_type_id, :as_on]
  validates_uniqueness_of :as_on, scope: [:business_unit_id, :cost_adder_type_id, :as_on]

  belongs_to :business_unit, :class_name => 'BusinessUnit', :foreign_key => :business_unit_id
  belongs_to :cost_adder_type, :class_name => 'CostAdderType', :foreign_key => :cost_adder_type_id
end
