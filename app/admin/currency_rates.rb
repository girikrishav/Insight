include ActiveAdminHelper

ActiveAdmin.register CurrencyRate, as: I18n.t('active_admin.currency_rate') do
  menu :if => proc { menu_accessible?(50) }, :label => I18n.t('active_admin.currency_rate').pluralize\
  , :parent => I18n.t('active_admin.master').pluralize, :priority => 90

  config.sort_order = 'as_on_desc'

  config.paginate = false

  action_item only: [:show] do
    link_to I18n.t('button_labels.cancel'), admin_currency_rates_path
  end

  batch_action :reciprocal do |ids|
    @selected = CurrencyRate.find(ids).count
    @total = CurrencyRate.all.count
    if @selected < @total
      @changes = false
      CurrencyRate.find(ids).each do |cr|
        @rows = CurrencyRate.where('from_currency_id = ? and to_currency_id = ? and as_on = ?', \
        cr.to_currency_id, cr.from_currency_id, cr.as_on).count
        if @rows == 0
          CurrencyRate.create(from_currency_id: cr.to_currency_id, to_currency_id: cr.from_currency_id, \
          as_on: cr.as_on, conversion_rate: (1 / cr.conversion_rate), comments: 'Reciprocal generated.')
          @changes = true
        end
      end
      if @changes
        redirect_to collection_path, alert: I18n.t('messages.reciprocals_done')
      else
        redirect_to collection_path, alert: I18n.t('messages.no_changes')
      end
    else
      @changes = false
      CurrencyRate.all.each do |cr|
        @rows = CurrencyRate.where('from_currency_id = ? and to_currency_id = ? and as_on = ?', \
        cr.to_currency_id, cr.from_currency_id, cr.as_on).count
        if @rows == 0
          CurrencyRate.create(from_currency_id: cr.to_currency_id, to_currency_id: cr.from_currency_id, \
          as_on: cr.as_on, conversion_rate: (1 / cr.conversion_rate), comments: 'Reciprocal generated.')
          @changes = true
        end
      end
      if @changes
        redirect_to collection_path, alert: I18n.t('messages.reciprocals_done')
      else
        redirect_to collection_path, alert: I18n.t('messages.no_changes')
      end
    end
  end

  controller do
    before_filter do |c|
      c.send(:is_user_authorized?, 50, url_for)
    end

    def scoped_collection
      end_of_association_chain.includes(:from_currency)
      end_of_association_chain.includes(:to_currency)
    end

    # To redirect create and update actions redirect to index page upon submit.
    def create
      super do |format|
        redirect_to collection_url and return if resource.valid?
      end
    end

    def update
      super do |format|
        redirect_to collection_url and return if resource.valid?
      end
    end
  end

  show do |cr|
    panel I18n.t('active_admin.currency_rate') + ' ' + I18n.t('active_admin.detail').pluralize do
      attributes_table_for cr do
        row :id
        row :from_currency
        row :to_currency
        row :as_on
        row :conversion_rate do
          number_with_precision cr.conversion_rate, precision: 4, delimiter: ','
        end
        row :created_at
        row :updated_at
        row :comments
      end
    end
  end

  filter :from_currency
  filter :to_currency
  filter :as_on
  filter :conversion_rate
  filter :comments
  filter :created_at
  filter :updated_at

  index do
    selectable_column
    column :id
    column :from_currency, :sortable => 'currencies.name'
    column :to_currency, :sortable => 'currencies.name'
    column :as_on
    column :conversion_rate, :sortable => 'conversion_rate' do |element|
      div :style => "text-align: right;" do
        number_with_precision element.conversion_rate, :precision => 4, delimiter: ','
      end
    end
    actions dropdown: :true
  end

  scope :all_by_as_on do |currencies|
    currencies.where("1 = 1").reorder('as_on DESC, from_currency_id ASC, to_currency_id ASC')
  end

  scope :all_by_from_currency do |currencies|
    currencies.where("1 = 1").reorder('from_currency_id ASC, to_currency_id ASC, as_on DESC')
  end

  scope :all_by_to_currency do |currencies|
    currencies.where("1 = 1").reorder('to_currency_id ASC, from_currency_id ASC, as_on DESC')
  end

  form do |f|
    f.inputs I18n.t('active_admin.currency_rate') + ' ' + I18n.t('active_admin.detail').pluralize do
      if params[:action] == "new" || params[:action] == "create"
        f.input :from_currency
        f.input :to_currency
        f.input :as_on, as: :datepicker
        f.input :conversion_rate
      else
        f.input :from_currency, :input_html => {:disabled => true}
        f.input :to_currency, :input_html => {:disabled => true}
        f.input :as_on, as: :datepicker, :input_html => {:disabled => true}
        f.input :conversion_rate, :input_html => {:disabled => true}
      end
      f.input :comments
    end
    f.actions
  end
end
