every 1.minute do
  rake "cleanup:old_soft_deleted_products", environment: "production"
end
