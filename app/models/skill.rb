class Skill < ActiveRecord::Base
  def self.applicable_skills
    applicable = []
    AssociateServiceRate.all.each do |asr|
      if !applicable.include? asr.service_rate.skill.id
        applicable.push(asr.service_rate.skill.id)
      end
    end
    Skill.where(id: applicable)
  end

  def applicable_designations
    applicable = []
    ServiceRate.where(skill_id: self.id).each do |sr|
      AssociateServiceRate.where(service_rate_id: sr.id).each do |asr|
        if !applicable.include? sr.id
          applicable.push(sr.id)
        end
      end
    end
    ServiceRate.where(id: applicable)
  end

  validates :name, presence: :true, uniqueness: :true
  validates :rank, presence: :true

  has_many :staffing_requirements, :class_name => 'StaffingRequirement'
  has_many :service_rates, :class_name => 'ServiceRate'
  has_many :assignments, :class_name => 'Assignment'
  has_many :assignment_histories, :class_name => 'AssignmentHistory'
  has_many :assignment_allocations, :class_name => 'AssignmentAllocation'
end
