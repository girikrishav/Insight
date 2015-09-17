class ServiceRate < ActiveRecord::Base
  def bu_currency
    Currency.find(BusinessUnit.find(self.business_unit_id).currency_id).name
  end

  def self.applicable_billing_rate(business_unit_id, skill_id, designation_id, as_on)
    @sr = ServiceRate.where('business_unit_id = ? and skill_id = ? and designation_id = ? and as_on <= ?' \
        , business_unit_id, skill_id, designation_id \
        , as_on).order('as_on desc').first
    if !@sr.nil?
      return @sr.billing_rate
    else
      return 0
    end
  end

  def self.applicable_cost_rate(business_unit_id, skill_id, designation_id, as_on)
    @sr = ServiceRate.where('business_unit_id = ? and skill_id = ? and designation_id = ? and as_on <= ?' \
        , business_unit_id, skill_id, designation_id \
        , as_on).order('as_on desc').first
    if !@sr.nil?
      return @sr.cost_rate
    else
      return 0
    end
  end

  def designation_name
    self.designation.name
  end

  def skill_designation
    self.skill.name + '|' + self.designation.name
  end

  def applicable_associates
    applicable = []
    AssociateServiceRate.all.each do |asr|
      if asr.service_rate.id == self.id
        if !applicable.include? asr.associate.id
          applicable.push(asr.associate.id)
        end
      end
    end
    Associate.where(id: applicable)
  end

  validates :business_unit, presence: :true
  validates :skill, presence: :true
  validates :designation, presence: :true
  validates :as_on, presence: :true
  validates :billing_rate, presence: :true
  validates :cost_rate, presence: :true

  validates_uniqueness_of :business_unit_id, scope: [:business_unit_id, :skill_id, :designation_id, :as_on]

  belongs_to :business_unit, :class_name => 'BusinessUnit', :foreign_key => :business_unit_id
  belongs_to :skill, :class_name => 'Skill', :foreign_key => :skill_id
  belongs_to :designation, :class_name => 'Designation', :foreign_key => :designation_id
  has_many :associate_service_rates, :class_name => 'AssociateServiceRate'
end
