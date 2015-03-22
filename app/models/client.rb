class Client < ActiveRecord::Base
  default_scope { order('name ASC') }

  validates :name, presence: :true, uniqueness: :true

  has_many :projects, :class_name => 'Project'
  has_many :project_histories, :class_name => 'ProjectHistory'
  has_many :pipelines, :class_name => 'Pipeline'
  has_many :pipeline_histories, :class_name => 'PipelineHistory'
end
