class AddFromDateToOverheads < ActiveRecord::Migration
  def change
    add_column :overheads, :from_date, :date
  end
end
