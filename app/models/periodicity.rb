class Periodicity < ActiveRecord::Base
  default_scope {order('rank ASC')}

  validates_uniqueness_of :name, scope: [:name]
  validates_uniqueness_of :rank, scope: [:rank]

  validates :name, presence: :true
  validates :rank, presence: :true

  def end_date(start_date)
    if :name == 'Monthly'
      start_date + 1.month - 1
    elsif :name == 'One-Time'
      start_date
    elsif :name == 'Weekly'
      start_date + 1.week - 1
    elsif :name == 'Annually'
      start_date + 1.year - 1
    elsif :name == 'Daily'
      start_date + 1.day - 1
    elsif :name == 'Quarterly'
      start_date + 3.month - 1
    elsif :name == 'Fortnightly'
      start_date + 2.week - 1
    elsif :name == 'Semi-Annually'
      start_date + 6.month - 1
    else
      start_date
    end
  end
end
