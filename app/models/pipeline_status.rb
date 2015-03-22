class PipelineStatus < ActiveRecord::Base
  validates :name, presence: :true, uniqueness: :true
  validates :rank, presence: :true

  has_many :pipelines, :class_name => 'Pipeline'
  has_many :pipeline_histories, :class_name => 'PipelineHistory'
end
