class Associate < ActiveRecord::Base
  default_scope { order('name ASC') }

  def bu_currency
    self.business_unit.bu_currency
  end

  def set_active
    if !self.dol.nil?
      self.is_active = FlagStatuses.find_by_name('No').id
    end
  end

  def self.allowed_ids(current_user_rank, current_user_id)
    allowed = Array[]
    AdminUser.all.each do |au|
      if au.allowed_check(current_user_rank, current_user_id)
        allowed.push(au.id)
      end
    end
    allowed
  end

  def self.allowed(current_user_rank, current_user_id)
    AdminUser.select { |au| au.allowed_check(current_user_rank, current_user_id) }
  end

  def allowed_check(current_user_rank, current_user_id)
    if Role.find(AdminUser.find(self.user_id).role_id).rank < current_user_rank\
        or self.user_id == current_user_id
      return true
    end
    return false
  end

  def doj_dol_check
    if !self.dol.nil?
      if self.doj > self.dol
        errors.add(:doj, I18n.t('errors.doj_dol_error'))
        errors.add(:dol, I18n.t('errors.doj_dol_error'))
      end
    end
  end

  def manager_check
    if !self.manager.nil?
      if self.manager.id == self.id
        errors.add(:manager, I18n.t('errors.manager_error'))
      end
    end
  end

  def one_user_check
    @assigned = Associate.where('user_id = ? and id != ?', self.user_id, self.id)
    if @assigned.count > 0
      errors.add(:user, I18n.t('errors.one_user_violation', name: @assigned.first.name \
        , id_no: @assigned.first.id_no))
    end
  end

  def create_history_record
    @db_row = Associate.find(self.id)
    @history_row = AssociateHistory.new(as_on: @db_row.as_on, associate_id: self.id\
        , associate_type_id: @db_row.associate_type_id\
        , business_unit_id: @db_row.business_unit_id, comments: @db_row.comments, department_id: @db_row.department_id\
        , doj: @db_row.doj, dol: @db_row.dol, id_no: @db_row.id_no\
        , is_active: @db_row.is_active, manager_id: @db_row.manager_id, name: @db_row.name\
        , user_id: @db_row.user_id)
    @history_row.save
  end

  before_create :set_active
  before_update :set_active

  after_save :create_history_record

  validates :as_on, presence: :true
  validates :doj, presence: :true
  validates :id_no, presence: :true, uniqueness: :true
  validates :name, presence: :true
  validates :user, presence: :true
  validates :business_unit, presence: :true
  validates :active, presence: :true
  validates :associate_type, presence: :true

  validates_uniqueness_of :name, scope: [:name, :as_on, :business_unit_id]

  validate :doj_dol_check
  validate :manager_check
  validate :one_user_check

  belongs_to :user, :class_name => 'AdminUser', :foreign_key => :user_id
  belongs_to :business_unit, :class_name => 'BusinessUnit', :foreign_key => :business_unit_id
  belongs_to :active, :class_name => 'FlagStatus', :foreign_key => :is_active
  belongs_to :associate_type, :class_name => 'AssociateType', :foreign_key => :associate_type_id
  belongs_to :department, :class_name => 'Department', :foreign_key => :department_id
  belongs_to :manager, :class_name => 'Associate', :foreign_key => :manager_id
  has_many :timesheet_histories, :class_name => 'TimesheetHistory'
  has_many :timesheet_clockings, :class_name => 'TimesheetClocking'
  has_many :projects, :class_name => 'Project'
  has_many :projects, :class_name => 'Project'
  has_many :projects, :class_name => 'Project'
  has_many :projects, :class_name => 'Project'
  has_many :project_histories, :class_name => 'ProjectHistory'
  has_many :project_histories, :class_name => 'ProjectHistory'
  has_many :project_histories, :class_name => 'ProjectHistory'
  has_many :project_histories, :class_name => 'ProjectHistory'
  has_many :pipelines, :class_name => 'Pipeline'
  has_many :pipelines, :class_name => 'Pipeline'
  has_many :pipelines, :class_name => 'Pipeline'
  has_many :pipelines, :class_name => 'Pipeline'
  has_many :pipeline_histories, :class_name => 'PipelineHistory'
  has_many :pipeline_histories, :class_name => 'PipelineHistory'
  has_many :pipeline_histories, :class_name => 'PipelineHistory'
  has_many :pipeline_histories, :class_name => 'PipelineHistory'
  has_many :associate_service_rates, :class_name => 'AssociateServiceRate'
  has_many :associate_histories, :class_name => 'AssociateHistory'
  has_many :associate_histories, :class_name => 'AssociateHistory'
  has_many :assignments, :class_name => 'Assignment'
  has_many :assignment_histories, :class_name => 'AssignmentHistory'
  has_many :assignment_allocations, :class_name => 'AssignmentAllocation'
end
