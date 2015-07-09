class Project < ActiveRecord::Base
  def bu_currency
    Currency.find(BusinessUnit.find(self.owner_business_unit_id).currency_id).name
  end

  def client_name
    Client.find(self.client_id).name
  end

  def bu_name
    BusinessUnit.find(self.owner_business_unit_id).name
  end

  def max_as_on
    Project.where('owner_business_unit_id = ? and client_id = ? and project_name = ?' \
        , self.owner_business_unit_id, self.client_id, self.project_name)\
        .reorder('as_on desc').first.as_on
  end

  def name
    "Project = " + self.project_name + " ["  + self.start_date.to_s + ", " + self.end_date.to_s + "]"\
        ", Client = " + self.client_name + ", BU = " + self.bu_name+ " [" + self.bu_currency + "]"\
        + ", As on = " + self.as_on.to_s
  end

  def self.allowed_ids(current_user_rank, highest_rank, current_user_id)
    allowed = Array[]
    Project.all.each do |p|
      if p.allowed_check(current_user_rank, highest_rank, current_user_id)\
          and p.as_on == p.max_as_on
        allowed.push(p.id)
      end
    end
    allowed
  end

  def allowed_check(current_user_rank, highest_rank, current_user_id)
    if !self.sales_associate_id.nil?
      if current_user_rank >\
          Role.find(AdminUser.find(Associate.find(self.sales_associate_id).user_id).role_id).rank\
          or Associate.find(self.sales_associate_id).user_id == current_user_id
        return true
      end
    elsif !self.estimator_associate_id.nil?
      if current_user_rank >\
          Role.find(AdminUser.find(Associate.find(self.estimator_associate_id).user_id).role_id).rank\
          or Associate.find(self.estimator_associate_id).user_id == current_user_id
        return true
      end
    elsif !self.account_manager_associate_id.nil?
      if current_user_rank >\
          Role.find(AdminUser.find(Associate.find(self.account_manager_associate_id).user_id).role_id).rank\
          or Associate.find(self.account_manager_associate_id).user_id == current_user_id
        return true
      end
    elsif !self.delivery_manager_associate_id.nil?
      if current_user_rank >\
          Role.find(AdminUser.find(Associate.find(self.delivery_manager_associate_id).user_id).role_id).rank\
          or Associate.find(self.delivery_manager_associate_id).user_id == current_user_id
        return true
      end
    elsif current_user_rank == highest_rank
      return true
    end
    return false
  end


  def create_history_record
    @db_row = Project.find(self.id)
    @history_row = ProjectHistory.new(account_manager_associate_id: @db_row.account_manager_associate_id\
        , client_id: @db_row.client_id, comments: @db_row.comments\
        , delivery_manager_associate_id: @db_row.delivery_manager_associate_id\
        , estimator_associate_id: @db_row.estimator_associate_id, start_date: @db_row.start_date\
        , end_date: @db_row.end_date, booking_amount: @db_row.booking_amount\
        , owner_business_unit_id: @db_row.owner_business_unit_id, project_status_id: @db_row.project_status_id\
        , project_description: @db_row.project_description, project_name: @db_row.project_name\
        , project_type_id: @db_row.project_type_id, sales_associate_id: @db_row.sales_associate_id\
        , as_on: @db_row.as_on, pipeline_id: self.pipeline_id, project_id: self.id)
    @history_row.save
  end

  def start_end_date_check
    if self.start_date > self.end_date
      errors.add(:start_date, I18n.t('errors.start_after_end_date'))
      errors.add(:end_date, I18n.t('errors.end_before_start_date'))
    end
  end

  def project_pipeline_bu_check
    if !self.pipeline_id.nil?
      if self.owner_business_unit_id != Pipeline.find(self.pipeline_id).owner_business_unit_id
        errors.add(:business_unit, I18n.t('errors.project_pipeline_bu_check'\
            , project_bu: BusinessUnits.find(self.owner_business_unit_id).name  \
            , pipeline_bu: BusinessUnits.find(Pipeline.find(self.pipeline_id).owner_business_unit_id).name))
        errors.add(:pipeline, I18n.t('errors.project_pipeline_bu_check'\
            , project_bu: BusinessUnits.find(self.owner_business_unit_id).name  \
            , pipeline_bu: BusinessUnits.find(Pipeline.find(self.pipeline_id).owner_business_unit_id).name))
      end
    end
  end

  after_save :create_history_record

  validates :account_manager_associate_id, presence: true
  validates :as_on, presence: :true
  validates :booking_amount, presence: :true
  validates :client_id, presence: :true
  validates :delivery_manager_associate_id, presence: :true
  validates :end_date, presence: :true
  validates :estimator_associate_id, presence: :true
  validates :owner_business_unit_id, presence: :true
  validates :project_name, presence: :true
  validates :project_status_id, presence: :true
  validates :project_type_id, presence: :true
  validates :sales_associate_id, presence: :true
  validates :start_date, presence: :true

  validates_uniqueness_of :client_id, scope: [:client_id, :project_name, :owner_business_unit_id, :as_on]
  validates_uniqueness_of :project_name, scope: [:client_id, :project_name, :owner_business_unit_id, :as_on]
  validates_uniqueness_of :owner_business_unit_id, scope: [:client_id, :project_name, :owner_business_unit_id, :as_on]
  validates_uniqueness_of :as_on, scope: [:client_id, :project_name, :owner_business_unit_id, :as_on]

  validate :start_end_date_check
  validate :project_pipeline_bu_check

  belongs_to :business_unit, :class_name => 'BusinessUnit', :foreign_key => :owner_business_unit_id
  belongs_to :delivery_manager_associate, :class_name => 'Associate', :foreign_key => :delivery_manager_associate_id
  belongs_to :account_manager_associate, :class_name => 'Associate', :foreign_key => :account_manager_associate_id
  belongs_to :estimator_associate, :class_name => 'Associate', :foreign_key => :estimator_associate_id
  belongs_to :sales_associate, :class_name => 'Associate', :foreign_key => :sales_associate_id
  belongs_to :client, :class_name => 'Client', :foreign_key => :client_id
  belongs_to :pipeline, :class_name => 'Pipeline', :foreign_key => :pipeline_id
  belongs_to :project_status, :class_name => 'ProjectStatus', :foreign_key => :project_status_id
  belongs_to :project_type, :class_name => 'ProjectType', :foreign_key => :project_type_id
  has_many :staffing_requirements, :class_name => 'StaffingRequirement'
  has_many :project_histories, :class_name => 'ProjectHistory'
  has_many :assignments, :class_name => 'Assignment'
  has_many :assignment_histories, :class_name => 'AssignmentHistory'
  has_many :assignment_allocations, :class_name => 'AssignmentAllocation'
end
