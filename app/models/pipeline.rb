class Pipeline < ActiveRecord::Base
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
    Pipeline.where('owner_business_unit_id = ? and client_id = ? and project_name = ?' \
        , self.owner_business_unit_id, self.client_id, self.project_name)\
        .reorder('as_on desc').first.as_on
  end

  def self.allowed_ids(current_user_rank, highest_rank, current_user_id)
    allowed = Array[]
    Pipeline.all.each do |p|
      if p.allowed_check(current_user_rank, highest_rank, current_user_id)\
          and p.as_on == p.max_as_on
        allowed.push(p.id)
      end
    end
    allowed
  end

  def self.allowed(current_user_rank, highest_rank, current_user_id)
    Pipeline.select { |p| p.allowed_check(current_user_rank, highest_rank, current_user_id)\
          and p.as_on == p.max_as_on }
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
    @db_row = Pipeline.find(self.id)
    @history_row = PipelineHistory.new(account_manager_associate_id: @db_row.account_manager_associate_id\
        , client_id: @db_row.client_id, comments: @db_row.comments\
        , delivery_manager_associate_id: @db_row.delivery_manager_associate_id\
        , estimator_associate_id: @db_row.estimator_associate_id, expected_end: @db_row.expected_end\
        , expected_start: @db_row.expected_start, expected_value: @db_row.expected_value\
        , owner_business_unit_id: @db_row.owner_business_unit_id, pipeline_status_id: @db_row.pipeline_status_id\
        , project_description: @db_row.project_description, project_name: @db_row.project_name\
        , project_type_id: @db_row.project_type_id, sales_associate_id: @db_row.sales_associate_id\
        , as_on: @db_row.as_on, pipeline_id: self.id)
    @history_row.save
  end


  def start_end_date_check
    if self.expected_start > self.expected_end
      errors.add(:expected_start, I18n.t('errors.start_after_end_date'))
      errors.add(:expected_end, I18n.t('errors.end_before_start_date'))
    end
  end

  def pipeline_project_bu_check
    if !self.id.nil?
      @db_row = Pipeline.find(self.id)
      if !@db_row.nil?
        if self.owner_business_unit_id != @db_row.owner_business_unit_id
          if Project.find_all_by_pipeline_id(self.id).count > 0
            errors.add(:owner_business_unit, I18n.t('errors.pipeline_project_bu_check'))
          end
        end
      end
    end
  end

  def name
    "Project name = " + self.project_name + ", Client = " + self.client_name\
        + ", BU = " + self.bu_name+ " [Currency = " + self.bu_currency + "]"\
        + ", As on = " + self.as_on.to_s
  end

  after_save :create_history_record

  validates :client, presence: :true
  validates :as_on, presence: :true
  validates :expected_end, presence: :true
  validates :expected_start, presence: :true
  validates :expected_value, presence: :true
  validates :business_unit, presence: :true
  validates :pipeline_status, presence: :true
  validates :project_name, presence: :true
  validates :project_type, presence: :true
  validates :sales_associate, presence: :true

  validates_uniqueness_of :client_id, scope: [:client_id, :project_name, :owner_business_unit_id, :as_on]
  validates_uniqueness_of :project_name, scope: [:client_id, :project_name, :owner_business_unit_id, :as_on]
  validates_uniqueness_of :owner_business_unit_id, scope: [:client_id, :project_name, :owner_business_unit_id, :as_on]
  validates_uniqueness_of :as_on, scope: [:client_id, :project_name, :owner_business_unit_id, :as_on]

  validate :start_end_date_check
  validate :pipeline_project_bu_check

  belongs_to :business_unit, :class_name => 'BusinessUnit', :foreign_key => :owner_business_unit_id
  belongs_to :delivery_manager_associate, :class_name => 'Associate', :foreign_key => :delivery_manager_associate_id
  belongs_to :account_manager_associate, :class_name => 'Associate', :foreign_key => :account_manager_associate_id
  belongs_to :estimator_associate, :class_name => 'Associate', :foreign_key => :estimator_associate_id
  belongs_to :sales_associate, :class_name => 'Associate', :foreign_key => :sales_associate_id
  belongs_to :client, :class_name => 'Client', :foreign_key => :client_id
  belongs_to :pipeline_status, :class_name => 'PipelineStatus', :foreign_key => :pipeline_status_id
  has_many :projects, :class_name => 'Project'
  has_many :pipeline_histories, :class_name => 'PipelineHistory'
  belongs_to :project_type, :class_name => 'ProjectType', :foreign_key => :project_type_id
end
