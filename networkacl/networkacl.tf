locals {
  example_addresses = [
    "192.168.10.10",
    "192.168.1.1-192.168.1.50"
  ]
}

data "huaweicloud_vpc_subnet" "subnet_test" {
  name = "test"
}

// IP地址组暂不支持data声明
resource "huaweicloud_vpc_address_group" "address_group_test" {
  name = "address_group_test"
  addresses = [
    "192.168.10.10",
    "192.168.1.1-192.168.1.50"
  ]
}

resource "huaweicloud_network_acl_rule" "subnet_1_inbound_rule" {
  count                  = length(huaweicloud_vpc_address_group.address_group_test.addresses) //
  description            = ""
  protocol               = "any"
  action                 = "allow"
  source_ip_address      = tolist(huaweicloud_vpc_address_group.address_group_test.addresses)[count.index] //
  source_port            = "any"
  destination_ip_address = "192.169.0.0/24"
  destination_port       = "any"
}

resource "huaweicloud_network_acl_rule" "subnet_1_outbound_rule" {
  description            = ""
  protocol               = "any"
  action                 = "allow"
  source_ip_address      = "192.169.0.0/24"
  source_port            = "any"
  destination_ip_address = "192.170.0.0/22"
  destination_port       = "443,8443,28511,28512,28521,28522"
}

resource "huaweicloud_network_acl_rule" "subnet_1_outbound_rule_2" {
  description            = ""
  protocol               = "any"
  action                 = "allow"
  source_ip_address      = "192.169.0.0/24"
  source_port            = "any"
  destination_ip_address = "192.170.3.0/22"
  destination_port       = "21,22"
}

resource "huaweicloud_network_acl" "network_acl_test" {
  name           = "acl_test"
  subnets        = [data.huaweicloud_vpc_subnet.subnet_test.id]
  inbound_rules  = huaweicloud_network_acl_rule.subnet_1_inbound_rule[*].id
  outbound_rules = [huaweicloud_network_acl_rule.subnet_1_outbound_rule.id, huaweicloud_network_acl_rule.subnet_1_outbound_rule_2.id]
}
