// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

instance_env                  = 0
instance_resource             = 0
logical_product_family        = "launch"
logical_product_service       = "funcapp"
class_env                     = "gotest"
location                      = "eastus"
public_network_access_enabled = false
address_space                 = ["10.0.0.0/16"]
subnets = {
  subnet1 = {
    name                                          = "subnet1"
    prefix                                        = "10.0.1.0/24"
    private_link_service_network_policies_enabled = true
  }
}
app_settings = {
  "FUNCTIONS_WORKER_RUNTIME"            = "dotnet"
  "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"
}
sku = "S1"
identity = {
  type = "SystemAssigned"
}
site_config = {
  ip_restriction_default_action = "Deny"
  scm_use_main_ip_restriction   = true
  ip_restriction = [{
    action     = "Allow"
    name       = "default-allow-app-subnet"
    priority   = "100000"
    ip_address = "10.10.0.0/24"
    },
    {
      action     = "Allow"
      name       = "default-allow-vnet-integration-subnet"
      priority   = "100001"
      ip_address = "10.10.1.0/24"
    },
    {
      action     = "Allow"
      name       = "default-allow-vmss-subnet"
      priority   = "100002"
      ip_address = "10.10.2.0/24"
    },
    {
      action     = "Allow"
      name       = "default-allow-camp-jump-box-subnet"
      priority   = "100003"
      ip_address = "10.10.3.0/24"
  }]
}
