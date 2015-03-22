class ProjectType < ActiveRecord::Base
  default_scope {order('rank ASC')}

  validates :name, presence: :true, uniqueness: :true
  validates :billed, presence: :true
  validates :rank, presence: :true

  belongs_to :billed, :class_name => 'FlagStatus', :foreign_key => :is_billed
  has_many :projects, :class_name => 'Project'
  has_many :project_histories, :class_name => 'ProjectHistory'
  has_many :pipelines, :class_name => 'Pipeline'
  has_many :pipeline_histories, :class_name => 'PipelineHistory'
end
