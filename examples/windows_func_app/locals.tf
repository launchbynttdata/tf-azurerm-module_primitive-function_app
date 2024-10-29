locals {
  resource_group_name  = module.resource_names["resource_group"].minimal_random_suffix
  function_app_name    = module.resource_names["function_app"].minimal_random_suffix
  service_plan_name    = module.resource_names["service_plan"].minimal_random_suffix
  storage_account_name = module.resource_names["storage_account"].minimal_random_suffix_without_any_separators
}
