output "default_hostname" {
  value = module.function_app.default_hostname
}

output "function_app_name" {
  value = module.function_app.function_app_name
}

output "function_app_id" {
  value = module.function_app.function_app_id
}

output "service_plan_name" {
  value = module.app_service_plan.name
}

output "service_plan_id" {
  value = module.app_service_plan.id
}

output "storage_account_id" {
  description = "The id of the storage account"
  value       = module.storage_account.id
}
