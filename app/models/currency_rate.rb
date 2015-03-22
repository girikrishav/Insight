class CurrencyRate < ActiveRecord::Base
  def validate_from_to_currencies
    if from_currency_id == to_currency_id
      errors.add(:from_currency, I18n.t('errors.from_to_currency_same'))
      errors.add(:to_currency, I18n.t('errors.from_to_currency_same'))
    end
  end

  validates :from_currency, presence: :true
  validates :to_currency, presence: :true
  validates :as_on, presence: :true
  validates :conversion_rate, presence: :true

  validates_uniqueness_of :from_currency_id, scope: [:from_currency_id, :to_currency_id, :as_on]
  validates_uniqueness_of :to_currency_id, scope: [:from_currency_id, :to_currency_id, :as_on]
  validates_uniqueness_of :as_on, scope: [:from_currency_id, :to_currency_id, :as_on]

  validate :validate_from_to_currencies

  belongs_to :from_currency, :class_name => 'Currency', foreign_key: :from_currency_id
  belongs_to :to_currency, :class_name => 'Currency', foreign_key: :to_currency_id
end
