
ActiveRecord::Schema[8.0].define(version: 2025_05_08_112430) do
  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource"
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "add_to_cards", force: :cascade do |t|
    t.integer "quantity"
    t.integer "admin_user_id", null: false
    t.integer "product_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["admin_user_id"], name: "index_add_to_cards_on_admin_user_id"
    t.index ["product_id"], name: "index_add_to_cards_on_product_id"
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "user_type"
    t.string "first_name"
    t.string "last_name"
    t.datetime "deleted_at"
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "businesses", force: :cascade do |t|
    t.string "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
  end

  create_table "orders", force: :cascade do |t|
    t.integer "user_id"
    t.integer "product_id", null: false
    t.integer "seller_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "business_id", null: false
    t.string "status_type", default: "ordered"
    t.integer "address_id"
    t.datetime "deleted_at"
    t.integer "quantity"
    t.index ["address_id"], name: "index_orders_on_address_id"
    t.index ["business_id"], name: "index_orders_on_business_id"
    t.index ["product_id"], name: "index_orders_on_product_id"
    t.index ["seller_id"], name: "index_orders_on_seller_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.string "brand_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "business_id", null: false
    t.integer "price"
    t.string "discription"
    t.decimal "rating", precision: 2, scale: 1
    t.datetime "deleted_at"
    t.index ["business_id"], name: "index_products_on_business_id"
  end

  create_table "ratings", force: :cascade do |t|
    t.string "comments"
    t.integer "rate"
    t.integer "admin_user_id", null: false
    t.integer "product_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "order_id", null: false
    t.datetime "deleted_at"
    t.index ["admin_user_id"], name: "index_ratings_on_admin_user_id"
    t.index ["order_id"], name: "index_ratings_on_order_id"
    t.index ["product_id"], name: "index_ratings_on_product_id"
  end

  create_table "seller_products", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "seller_id", null: false
    t.bigint "product_id", null: false
    t.integer "sold_count"
    t.integer "business_id", null: false
    t.datetime "deleted_at"
    t.index ["business_id"], name: "index_seller_products_on_business_id"
    t.index ["product_id"], name: "index_seller_products_on_product_id"
    t.index ["seller_id"], name: "index_seller_products_on_seller_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.integer "product_id", null: false
    t.integer "seller_id"
    t.decimal "amount", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_transactions_on_deleted_at"
    t.index ["product_id"], name: "index_transactions_on_product_id"
    t.index ["seller_id"], name: "index_transactions_on_seller_id"
  end

  create_table "user_addresses", force: :cascade do |t|
    t.string "country"
    t.string "state"
    t.string "dist"
    t.string "block"
    t.string "town"
    t.integer "gali_no"
    t.integer "house_no"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.datetime "deleted_at"
    t.index ["user_id"], name: "index_user_addresses_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "add_to_cards", "admin_users"
  add_foreign_key "add_to_cards", "products"
  add_foreign_key "orders", "admin_users", column: "seller_id"
  add_foreign_key "orders", "businesses"
  add_foreign_key "orders", "user_addresses", column: "address_id"
  add_foreign_key "products", "businesses"
  add_foreign_key "ratings", "admin_users"
  add_foreign_key "ratings", "orders"
  add_foreign_key "ratings", "products"
  add_foreign_key "seller_products", "businesses"
  add_foreign_key "transactions", "admin_users", column: "seller_id"
  add_foreign_key "transactions", "products"
  add_foreign_key "user_addresses", "admin_users", column: "user_id"
end
