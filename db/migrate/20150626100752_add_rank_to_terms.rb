class AddRankToTerms < ActiveRecord::Migration
  def change
    add_column :terms, :rank, :decimal
  end
end
