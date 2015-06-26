# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150626100752) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: true do |t|
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_admin_notes_on_resource_type_and_resource_id", using: :btree

  create_table "admin_users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "role_id"
    t.integer  "is_active"
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "assignment_allocations", force: true do |t|
    t.integer  "project_id"
    t.integer  "skill_id"
    t.integer  "designation_id"
    t.integer  "associate_id"
    t.date     "start_date"
    t.date     "end_date"
    t.string   "comments"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.decimal  "hours_per_day"
    t.integer  "assignment_id"
  end

  create_table "assignment_histories", force: true do |t|
    t.date     "as_on"
    t.integer  "associate_id"
    t.string   "comments"
    t.integer  "delivery_due_alert_id"
    t.integer  "designation_id"
    t.date     "end_date"
    t.decimal  "hours_per_day"
    t.integer  "invoicing_due_alert_id"
    t.integer  "payment_due_alert_id"
    t.integer  "project_id"
    t.integer  "skill_id"
    t.date     "start_date"
    t.integer  "assignment_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "assignments", force: true do |t|
    t.date     "start_date"
    t.date     "end_date"
    t.decimal  "hours_per_day"
    t.date     "as_on"
    t.string   "comments"
    t.integer  "project_id"
    t.integer  "skill_id"
    t.integer  "designation_id"
    t.integer  "associate_id"
    t.integer  "delivery_due_alert_id"
    t.integer  "invoicing_due_alert_id"
    t.integer  "payment_due_alert_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "associate_histories", force: true do |t|
    t.date     "as_on"
    t.string   "comments"
    t.date     "doj"
    t.date     "dol"
    t.string   "id_no"
    t.string   "name"
    t.integer  "user_id"
    t.integer  "manager_id"
    t.integer  "department_id"
    t.integer  "business_unit_id"
    t.integer  "is_active"
    t.integer  "associate_type_id"
    t.integer  "associate_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "associate_service_rates", force: true do |t|
    t.integer  "service_rate_id"
    t.integer  "associate_id"
    t.date     "as_on"
    t.decimal  "billing_rate"
    t.decimal  "cost_rate"
    t.string   "comments"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "associate_types", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.decimal  "rank"
    t.string   "comments"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "associates", force: true do |t|
    t.string   "name"
    t.date     "as_on"
    t.string   "id_no"
    t.date     "doj"
    t.date     "dol"
    t.string   "comments"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "user_id"
    t.integer  "manager_id"
    t.integer  "department_id"
    t.integer  "business_unit_id"
    t.integer  "is_active"
    t.integer  "associate_type_id"
  end

  create_table "business_units", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.decimal  "rank"
    t.string   "comments"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "currency_id"
  end

  create_table "clients", force: true do |t|
    t.string   "name"
    t.string   "address"
    t.string   "contact_name"
    t.string   "email"
    t.string   "phone"
    t.string   "fax"
    t.string   "comments"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "cost_adder_types", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.decimal  "rank"
    t.string   "comments"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "currencies", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "comments"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "currency_rates", force: true do |t|
    t.integer  "from_currency_id"
    t.integer  "to_currency_id"
    t.date     "as_on"
    t.decimal  "conversion_rate"
    t.string   "comments"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "delivery_milestones", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.date     "due_date"
    t.date     "last_reminder_date"
    t.date     "completion_date"
    t.string   "comments"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "departments", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.decimal  "rank"
    t.string   "comments"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "designations", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.decimal  "rank"
    t.string   "comments"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "flag_statuses", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.decimal  "rank"
    t.string   "comments"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "holidays", force: true do |t|
    t.date     "as_on"
    t.string   "name"
    t.string   "description"
    t.integer  "business_unit_id"
    t.string   "comments"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "invoice_adder_types", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.decimal  "rank"
    t.date     "applicable_date"
    t.decimal  "rate_applicable"
    t.string   "comments"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "invoice_statuses", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.decimal  "rank"
    t.string   "comments"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "invoicing_milestones", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.decimal  "amount"
    t.date     "due_date"
    t.date     "last_reminder_date"
    t.date     "completion_date"
    t.string   "comments"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "overheads", force: true do |t|
    t.decimal  "amount"
    t.string   "comments"
    t.integer  "business_unit_id"
    t.integer  "cost_adder_type_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.date     "from_date"
    t.integer  "periodicity_id"
    t.date     "to_date"
  end

  create_table "payment_statuses", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.decimal  "rank"
    t.string   "comments"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "periodicities", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.decimal  "rank"
    t.string   "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pipeline_histories", force: true do |t|
    t.string   "project_name"
    t.date     "expected_start"
    t.date     "expected_end"
    t.decimal  "expected_value"
    t.string   "project_description"
    t.string   "comments"
    t.integer  "client_id"
    t.integer  "project_type_id"
    t.integer  "pipeline_status_id"
    t.integer  "owner_business_unit_id"
    t.integer  "sales_associate_id"
    t.integer  "estimator_associate_id"
    t.integer  "account_manager_associate_id"
    t.integer  "delivery_manager_associate_id"
    t.integer  "pipeline_id"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.date     "as_on"
  end

  create_table "pipeline_statuses", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.decimal  "rank"
    t.string   "comments"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "pipelines", force: true do |t|
    t.string   "project_name"
    t.date     "expected_start"
    t.date     "expected_end"
    t.decimal  "expected_value"
    t.string   "project_description"
    t.string   "comments"
    t.integer  "client_id"
    t.integer  "project_type_id"
    t.integer  "pipeline_status_id"
    t.integer  "owner_business_unit_id"
    t.integer  "sales_associate_id"
    t.integer  "estimator_associate_id"
    t.integer  "account_manager_associate_id"
    t.integer  "delivery_manager_associate_id"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.date     "as_on"
  end

  create_table "project_histories", force: true do |t|
    t.string   "project_name"
    t.string   "project_description"
    t.date     "as_on"
    t.date     "start_date"
    t.date     "end_date"
    t.decimal  "booking_amount"
    t.integer  "client_id"
    t.integer  "project_type_id"
    t.integer  "project_status_id"
    t.integer  "sales_associate_id"
    t.integer  "estimator_associate_id"
    t.integer  "account_manager_associate_id"
    t.integer  "delivery_manager_associate_id"
    t.integer  "pipeline_id"
    t.integer  "owner_business_unit_id"
    t.string   "comments"
    t.integer  "project_id"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  create_table "project_statuses", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.decimal  "rank"
    t.string   "comments"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "project_types", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "is_billed"
    t.decimal  "rank"
    t.string   "comments"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "projects", force: true do |t|
    t.string   "project_name"
    t.string   "project_description"
    t.date     "as_on"
    t.date     "start_date"
    t.date     "end_date"
    t.decimal  "booking_amount"
    t.integer  "client_id"
    t.integer  "project_type_id"
    t.integer  "project_status_id"
    t.integer  "sales_associate_id"
    t.integer  "estimator_associate_id"
    t.integer  "account_manager_associate_id"
    t.integer  "delivery_manager_associate_id"
    t.integer  "pipeline_id"
    t.integer  "owner_business_unit_id"
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.string   "comments",                      limit: nil
  end

  create_table "roles", force: true do |t|
    t.string   "name"
    t.decimal  "rank"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "service_rates", force: true do |t|
    t.integer  "business_unit_id"
    t.integer  "skill_id"
    t.integer  "designation_id"
    t.date     "as_on"
    t.decimal  "billing_rate"
    t.decimal  "cost_rate"
    t.string   "comments"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "skills", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.decimal  "rank"
    t.string   "comments"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "staffing_requirements", force: true do |t|
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "number_required"
    t.decimal  "hours_per_day"
    t.string   "comments"
    t.integer  "skill_id"
    t.integer  "designation_id"
    t.integer  "is_fulfilled"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "project_id"
  end

  create_table "terms", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "days"
    t.string   "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "rank"
  end

  create_table "timesheet_clockings", force: true do |t|
    t.integer  "timesheet_id"
    t.integer  "associate_id"
    t.date     "as_on"
    t.decimal  "hours"
    t.string   "comments"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "timesheet_histories", force: true do |t|
    t.date     "as_on"
    t.integer  "associate_id"
    t.string   "comments"
    t.decimal  "hours"
    t.integer  "timesheet_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "timesheet_histories", ["associate_id"], name: "fki_timesheet_histories_associates_id_fk", using: :btree

  create_table "timesheets", force: true do |t|
    t.integer  "assignment_id"
    t.date     "as_on"
    t.decimal  "hours"
    t.string   "comments"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "user_statuses", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.decimal  "rank"
    t.string   "comments"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "vacation_reasons", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "is_paid"
    t.decimal  "days_allowed"
    t.string   "comments"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "business_unit_id"
  end

  add_foreign_key "admin_users", "roles", name: "admin_users_role_id_fk"
  add_foreign_key "admin_users", "user_statuses", name: "admin_users_is_active_fk", column: "is_active"

  add_foreign_key "assignment_allocations", "assignments", name: "assignment_allocations_assignment_id_fk"
  add_foreign_key "assignment_allocations", "associates", name: "assignment_allocations_associate_id_fk"
  add_foreign_key "assignment_allocations", "designations", name: "assignment_allocations_designation_id_fk"
  add_foreign_key "assignment_allocations", "projects", name: "assignment_allocations_project_id_fk"
  add_foreign_key "assignment_allocations", "skills", name: "assignment_allocations_skill_id_fk"

  add_foreign_key "assignment_histories", "assignments", name: "assignment_histories_assignment_id_fk"
  add_foreign_key "assignment_histories", "associates", name: "assignment_histories_associate_id_fk"
  add_foreign_key "assignment_histories", "designations", name: "assignment_histories_designation_id_fk"
  add_foreign_key "assignment_histories", "flag_statuses", name: "assignment_histories_delivery_due_alert_id_fk", column: "delivery_due_alert_id"
  add_foreign_key "assignment_histories", "flag_statuses", name: "assignment_histories_invoicing_due_alert_id_fk", column: "invoicing_due_alert_id"
  add_foreign_key "assignment_histories", "flag_statuses", name: "assignment_histories_payment_due_alert_id_fk", column: "payment_due_alert_id"
  add_foreign_key "assignment_histories", "projects", name: "assignment_histories_project_id_fk"
  add_foreign_key "assignment_histories", "skills", name: "assignment_histories_skill_id_fk"

  add_foreign_key "assignments", "associates", name: "assignments_associate_id_fk"
  add_foreign_key "assignments", "designations", name: "assignments_designation_id_fk"
  add_foreign_key "assignments", "flag_statuses", name: "assignments_delivery_due_alert_fk", column: "delivery_due_alert_id"
  add_foreign_key "assignments", "flag_statuses", name: "assignments_invoicing_due_alert_fk", column: "invoicing_due_alert_id"
  add_foreign_key "assignments", "flag_statuses", name: "assignments_payment_due_alert_fk", column: "payment_due_alert_id"
  add_foreign_key "assignments", "projects", name: "assignments_project_id_fk"
  add_foreign_key "assignments", "skills", name: "assignments_skill_id_fk"

  add_foreign_key "associate_histories", "admin_users", name: "associate_histories_user_id_fk", column: "user_id"
  add_foreign_key "associate_histories", "associate_types", name: "associate_histories_associate_type_id_fk"
  add_foreign_key "associate_histories", "associates", name: "associate_histories_associate_id_fk"
  add_foreign_key "associate_histories", "associates", name: "associate_histories_manager_id_fk", column: "manager_id"
  add_foreign_key "associate_histories", "business_units", name: "associate_histories_business_unit_id_fk"
  add_foreign_key "associate_histories", "departments", name: "associate_histories_department_id_fk"
  add_foreign_key "associate_histories", "flag_statuses", name: "associate_histories_is_active_fk", column: "is_active"

  add_foreign_key "associate_service_rates", "associates", name: "associate_service_rates_associate_id_fk"
  add_foreign_key "associate_service_rates", "service_rates", name: "associate_service_rates_service_rate_id_fk"

  add_foreign_key "associates", "admin_users", name: "associates_user_id_fk", column: "user_id"
  add_foreign_key "associates", "associate_types", name: "associates_associate_type_id_fk"
  add_foreign_key "associates", "associates", name: "associates_manager_id_fk", column: "manager_id"
  add_foreign_key "associates", "business_units", name: "associates_business_unit_id_fk"
  add_foreign_key "associates", "departments", name: "associates_department_id_fk"
  add_foreign_key "associates", "flag_statuses", name: "associates_is_active_fk", column: "is_active"

  add_foreign_key "business_units", "currencies", name: "business_units_currency_id_fk"

  add_foreign_key "holidays", "business_units", name: "holidays_business_unit_id_fk"

  add_foreign_key "overheads", "business_units", name: "overheads_business_unit_id_fk"
  add_foreign_key "overheads", "cost_adder_types", name: "overheads_cost_adder_type_id_fk"

  add_foreign_key "pipeline_histories", "associates", name: "pipeline_histories_account_manager_associate_id_fk", column: "account_manager_associate_id"
  add_foreign_key "pipeline_histories", "associates", name: "pipeline_histories_delivery_manager_associate_id_fk", column: "delivery_manager_associate_id"
  add_foreign_key "pipeline_histories", "associates", name: "pipeline_histories_estimator_associate_id_fk", column: "estimator_associate_id"
  add_foreign_key "pipeline_histories", "associates", name: "pipeline_histories_sales_associate_id_fk", column: "sales_associate_id"
  add_foreign_key "pipeline_histories", "business_units", name: "pipeline_histories_owner_business_unit_id_fk", column: "owner_business_unit_id"
  add_foreign_key "pipeline_histories", "clients", name: "pipeline_histories_client_id_fk"
  add_foreign_key "pipeline_histories", "pipeline_statuses", name: "pipeline_histories_pipeline_status_id_fk"
  add_foreign_key "pipeline_histories", "pipelines", name: "pipeline_histories_pipeline_id_fk"
  add_foreign_key "pipeline_histories", "project_types", name: "pipeline_histories_project_type_id_fk"

  add_foreign_key "pipelines", "associates", name: "pipelines_account_manager_associate_id_fk", column: "account_manager_associate_id"
  add_foreign_key "pipelines", "associates", name: "pipelines_delivery_manager_associate_id_fk", column: "delivery_manager_associate_id"
  add_foreign_key "pipelines", "associates", name: "pipelines_estimator_associate_id_fk", column: "estimator_associate_id"
  add_foreign_key "pipelines", "associates", name: "pipelines_sales_associate_id_fk", column: "sales_associate_id"
  add_foreign_key "pipelines", "business_units", name: "pipelines_owner_business_unit_id_fk", column: "owner_business_unit_id"
  add_foreign_key "pipelines", "clients", name: "pipelines_client_id_fk"
  add_foreign_key "pipelines", "pipeline_statuses", name: "pipelines_pipeline_status_id_fk"
  add_foreign_key "pipelines", "project_types", name: "pipelines_project_type_id_fk"

  add_foreign_key "project_histories", "associates", name: "project_histories_account_manager_associate_id_fk", column: "account_manager_associate_id"
  add_foreign_key "project_histories", "associates", name: "project_histories_delivery_manager_associate_id_fk", column: "delivery_manager_associate_id"
  add_foreign_key "project_histories", "associates", name: "project_histories_estimator_associate_id_fk", column: "estimator_associate_id"
  add_foreign_key "project_histories", "associates", name: "project_histories_sales_associate_id_fk", column: "sales_associate_id"
  add_foreign_key "project_histories", "business_units", name: "project_histories_owner_business_unit_id_fk", column: "owner_business_unit_id"
  add_foreign_key "project_histories", "clients", name: "project_histories_client_id_fk"
  add_foreign_key "project_histories", "project_statuses", name: "project_histories_project_status_id_fk"
  add_foreign_key "project_histories", "project_types", name: "project_histories_project_type_id_fk"
  add_foreign_key "project_histories", "projects", name: "project_histories_project_id_fk"

  add_foreign_key "project_types", "flag_statuses", name: "project_types_billed_fk", column: "is_billed"

  add_foreign_key "projects", "associates", name: "projects_account_manager_associate_id_fk", column: "account_manager_associate_id"
  add_foreign_key "projects", "associates", name: "projects_delivery_manager_associate_id_fk", column: "delivery_manager_associate_id"
  add_foreign_key "projects", "associates", name: "projects_estimator_associate_id_fk", column: "estimator_associate_id"
  add_foreign_key "projects", "associates", name: "projects_sales_associate_id_fk", column: "sales_associate_id"
  add_foreign_key "projects", "business_units", name: "projects_owner_business_unit_id_fk", column: "owner_business_unit_id"
  add_foreign_key "projects", "clients", name: "projects_client_id_fk"
  add_foreign_key "projects", "pipelines", name: "projects_pipeline_id_fk"
  add_foreign_key "projects", "project_statuses", name: "projects_project_status_id_fk"
  add_foreign_key "projects", "project_types", name: "projects_project_type_id_fk"

  add_foreign_key "service_rates", "business_units", name: "service_rates_business_unit_id_fk"
  add_foreign_key "service_rates", "designations", name: "service_rates_designation_id_fk"
  add_foreign_key "service_rates", "skills", name: "service_rates_skill_id_fk"

  add_foreign_key "staffing_requirements", "designations", name: "staffing_requirements_designation_id_fk"
  add_foreign_key "staffing_requirements", "flag_statuses", name: "staffing_requirements_is_fulfilled_fk", column: "is_fulfilled"
  add_foreign_key "staffing_requirements", "projects", name: "staffing_requirements_project_id_fk"
  add_foreign_key "staffing_requirements", "skills", name: "staffing_requirements_skill_id_fk"

  add_foreign_key "timesheet_clockings", "associates", name: "timesheet_clockings_associate_id_fk"
  add_foreign_key "timesheet_clockings", "timesheets", name: "timesheet_clockings_timesheet_id_fk"

  add_foreign_key "timesheet_histories", "associates", name: "timesheet_histories_associates_id_fk"
  add_foreign_key "timesheet_histories", "timesheets", name: "timesheet_histories_timesheet_id_fk"

  add_foreign_key "timesheets", "assignments", name: "timesheets_assignment_id_fk"

  add_foreign_key "vacation_reasons", "business_units", name: "vacation_reasons_business_unit_id_fk"
  add_foreign_key "vacation_reasons", "flag_statuses", name: "vacation_reasons_paid_fk", column: "is_paid"

end
