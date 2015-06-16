class RemoveDaysFromPeriodicities < ActiveRecord::Migration
  def change
    remove_column :periodicities, :days
  end
end
