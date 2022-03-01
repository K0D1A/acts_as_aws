# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 7) do

  create_table "certificates", force: :cascade do |t|
    t.integer "client_id", null: false
    t.string "acm_certificate_arn"
    t.string "acm_certificate_name"
    t.string "acm_certificate_status"
    t.string "acm_certificate_error"
    t.string "certificate"
    t.string "private_key"
    t.string "ca_bundle"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["client_id"], name: "index_certificates_on_client_id"
  end

  create_table "clients", force: :cascade do |t|
    t.integer "credentials_id", null: false
    t.string "aws_region"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["credentials_id"], name: "index_clients_on_credentials_id"
  end

  create_table "credentials", force: :cascade do |t|
    t.string "aws_access_key"
    t.string "aws_secret_key"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "http_listeners", force: :cascade do |t|
    t.integer "load_balancer_id", null: false
    t.string "elb_http_listener_arn"
    t.string "elb_http_listener_status"
    t.string "elb_http_listener_error"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["load_balancer_id"], name: "index_http_listeners_on_load_balancer_id"
  end

  create_table "https_listeners", force: :cascade do |t|
    t.integer "load_balancer_id", null: false
    t.integer "certificate_id", null: false
    t.string "elb_ssl_policy"
    t.string "elb_https_listener_arn"
    t.string "elb_https_listener_status"
    t.string "elb_https_listener_error"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["certificate_id"], name: "index_https_listeners_on_certificate_id"
    t.index ["load_balancer_id"], name: "index_https_listeners_on_load_balancer_id"
  end

  create_table "load_balancers", force: :cascade do |t|
    t.integer "client_id", null: false
    t.string "aws_load_balancer_arn"
    t.string "aws_load_balancer_status"
    t.string "aws_load_balancer_error"
    t.string "name"
    t.string "hostname"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["client_id"], name: "index_load_balancers_on_client_id"
  end

  create_table "target_groups", force: :cascade do |t|
    t.integer "client_id", null: false
    t.string "elb_target_group_arn"
    t.string "elb_target_group_name"
    t.string "elb_target_group_status"
    t.string "elb_target_group_error"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["client_id"], name: "index_target_groups_on_client_id"
  end

  add_foreign_key "certificates", "clients"
  add_foreign_key "clients", "credentials", column: "credentials_id"
  add_foreign_key "http_listeners", "load_balancers"
  add_foreign_key "https_listeners", "certificates"
  add_foreign_key "https_listeners", "load_balancers"
  add_foreign_key "load_balancers", "clients"
  add_foreign_key "target_groups", "clients"
end
