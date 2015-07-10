class BusinessUnit < ActiveRecord::Base
  default_scope { order('rank ASC') }

  def bu_currency
    Currency.find(self.currency_id).name
  end

  def name_with_currency
    self.name + ' [In = ' + self.bu_currency + ']'
  end

  validates :name, presence: :true, uniqueness: :true
  validates :rank, presence: :true
  validates :currency, presence: :true

  has_many :vacation_reasons, :class_name => 'VacationReason'
  has_many :service_rates, :class_name => 'ServiceRate'
  has_many :projects, :class_name => 'Project'
  has_many :project_histories, :class_name => 'ProjectHistory'
  has_many :pipelines, :class_name => 'Pipeline'
  has_many :pipeline_histories, :class_name => 'PipelineHistory'
  has_many :overheads, :class_name => 'Overhead'
  has_many :holidays, :class_name => 'Holiday'
  has_many :associates, :class_name => 'Associate'
  has_many :associate_histories, :class_name => 'AssociateHistory'
  belongs_to :currency, :class_name => 'Currency', :foreign_key => :currency_id
end
