class Periodicity < ActiveRecord::Base
  default_scope {order('rank ASC')}

  validates_uniqueness_of :name, scope: [:name]
  validates_uniqueness_of :rank, scope: [:rank]

  validates :name, presence: :true
  validates :rank, presence: :true

  def end_date(start_date)
    if :name == I18n.t('tokens.monthly')
      start_date + 1.month - 1
    elsif :name == I18n.t('tokens.one-time')
      start_date
    elsif :name == I18n.t('tokens.weekly')
      start_date + 1.week - 1
    elsif :name == I18n.t('tokens.annually')
      start_date + 1.year - 1
    elsif :name == I18n.t('tokens.daily')
      start_date + 1.day - 1
    elsif :name == I18n.t('tokens.quarterly')
      start_date + 3.month - 1
    elsif :name == I18n.t('tokens.fortnightly')
      start_date + 2.week - 1
    elsif :name == I18n.t('tokens.semi-annually')
      start_date + 6.month - 1
    else
      start_date
    end
  end
end
