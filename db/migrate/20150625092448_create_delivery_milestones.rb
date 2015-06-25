class CreateDeliveryMilestones < ActiveRecord::Migration
  def change
    create_table :delivery_milestones do |t|
      t.string :name
      t.string :description
      t.date :due_date
      t.date :last_reminder_date
      t.date :completion_date
      t.string :comments
      t.integer :project_id

      t.timestamps
    end
  end
end
