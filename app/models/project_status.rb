class ProjectStatus < ActiveRecord::Base
  default_scope { order('rank ASC') }

  validates :name, presence: :true, uniqueness: :true
  validates :rank, presence: :true

  has_many :projects, :class_name => 'Project'
  has_many :project_histories, :class_name => 'ProjectHistory'
end
