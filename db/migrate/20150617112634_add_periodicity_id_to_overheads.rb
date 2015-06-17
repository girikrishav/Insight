class AddPeriodicityIdToOverheads < ActiveRecord::Migration
  def change
    add_column :overheads, :periodicity_id, :integer
  end
end
