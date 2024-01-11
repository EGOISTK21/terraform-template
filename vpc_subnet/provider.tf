terraform {
  required_providers {
    huaweicloud = {
      source  = "huaweicloud/huaweicloud"
      version = "1.60.1"
    }
  }
}

provider "huaweicloud" {
  region                = "cn-east-3"
  project_id            = ""
  enterprise_project_id = "0"
  access_key            = ""
  secret_key            = ""
}
