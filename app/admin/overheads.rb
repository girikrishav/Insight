include ActiveAdminHelper

ActiveAdmin.register Overhead, as: "Overhead" do
  menu :if => proc { menu_accessible?(65) }, :label => "Overheads", :parent => "Operations", :priority => 20

  config.sort_order = 'from_date_desc'

  action_item only: [:show] do
    link_to "Cancel", admin_overheads_path
  end

  controller do
    before_filter do |c|
      c.send(:is_user_authorized?, 65, url_for)
    end

    def scoped_collection
      end_of_association_chain.includes(:business_unit)
      end_of_association_chain.includes(:cost_adder_type)
      end_of_association_chain.includes(:periodicity)
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

    def compute_from_date
      to_date = params[:to_date].to_date + 1
      periodicity = params[:periodicity]
      if Periodicity.find(periodicity).name.upcase == "MONTHLY"
        to_date -= 1.month
      elsif Periodicity.find(periodicity).name.upcase == "WEEKLY"
        to_date -= 1.week
      elsif Periodicity.find(periodicity).name.upcase == "ANNUALLY"
        to_date -= 1.year
      elsif Periodicity.find(periodicity).name.upcase == "QUARTERLY"
        to_date -= 3.month
      elsif Periodicity.find(periodicity).name.upcase == "FORTNIGHTLY"
        to_date -= 2.week
      elsif Periodicity.find(periodicity).name.upcase == "SEMI-ANNUALLY"
        to_date -= 6.month
      else
        to_date -= 1
      end
      render json: '{"from_date":"' + to_date.to_s + '"}'
    end

    def compute_to_date
      from_date = params[:from_date].to_date - 1
      periodicity = params[:periodicity]
      if Periodicity.find(periodicity).name.upcase == "MONTHLY"
        from_date += 1.month
      elsif Periodicity.find(periodicity).name.upcase == "WEEKLY"
        from_date += 1.week
      elsif Periodicity.find(periodicity).name.upcase == "ANNUALLY"
        from_date += 1.year
      elsif Periodicity.find(periodicity).name.upcase == "QUARTERLY"
        from_date += 3.month
      elsif Periodicity.find(periodicity).name.upcase == "FORTNIGHTLY"
        from_date += 2.week
      elsif Periodicity.find(periodicity).name.upcase == "SEMI-ANNUALLY"
        from_date += 6.month
      else
        from_date += 1
      end
      render json: '{"to_date":"' + from_date.to_s + '"}'
    end
  end

  show do |o|
    panel 'Overhead Details' do
      attributes_table_for o do
        row :id
        row :business_unit
        row :cost_adder_type
        row :from_date
        row :periodicity
        row :to_date
        row :bu_currency
        row :amount do
          number_with_precision o.amount, precision: 2, delimiter: ','
        end
        row :created_at
        row :updated_at
        row :comments
      end
    end
  end

  filter :business_unit
  filter :cost_adder_type
  filter :from_date
  filter :periodicity
  filter :to_date
  filter :amount
  filter :comments
  filter :created_at
  filter :updated_at

  index do
    selectable_column
    column :id
    column :business_unit
    column :cost_adder_type
    column :from_date
    column :periodicity
    column :to_date
    column "Currency", :bu_currency, sortable: false
    column "Amount", :amount, :sortable => 'amount' do |element|
      div :style => "text-align: right;" do
        number_with_precision element.amount, :precision => 2, delimiter: ','
      end
    end
    actions  dropdown: :true
  end

  form do |f|
    f.inputs "Overhead Details" do
      if params[:action] == "new" || params[:action] == "create"
        f.input :business_unit, as: :select, collection: BusinessUnit.all\
          .map { |fs| [fs.name_with_currency, fs.id] }
        f.input :cost_adder_type
        f.input :from_date, as: :datepicker, :input_html => {:value => Date.today}
        f.input :periodicity, as: :select, collection: Periodicity.all\
          .map { |fs| [fs.name, fs.id] }
        f.input :to_date, as: :datepicker
      else
        f.input :business_unit, :input_html => {:disabled => true}
        f.input :cost_adder_type, :input_html => {:disabled => true}
        f.input :from_date, :input_html => {:disabled => true}
        f.input :periodicity, :input_html => {:disabled => true}
        f.input :to_date, :input_html => {:disabled => true}
      end
      if params[:action] != "new" && params[:action] != "create"
        f.input :bu_currency, :label => 'Currency', :input_html => {:disabled => true}
      end
      f.input :amount
      f.input :comments
    end
    f.actions
  end
end
