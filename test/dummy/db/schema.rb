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

ActiveRecord::Schema.define(version: 4) do

  create_table "certificates", force: :cascade do |t|
    t.integer "client_id", null: false
    t.string "acm_certificate_arn"
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

  add_foreign_key "certificates", "clients"
  add_foreign_key "clients", "credentials", column: "credentials_id"
  add_foreign_key "load_balancers", "clients"
end
