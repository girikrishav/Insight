class RemoveAsOnFromOverheads < ActiveRecord::Migration
  def change
    remove_column :overheads, :as_on
  end
end
