class AddToDateToOverheads < ActiveRecord::Migration
  def change
    add_column :overheads, :to_date, :date
  end
end
