resource "huaweicloud_networking_secgroup" "secgroup_test" {
  name = "secgroup_test"
}

resource "huaweicloud_networking_secgroup_rule" "secgroup_rules_test" {
  security_group_id = huaweicloud_networking_secgroup.secgroup_test.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
}


// IP地址组暂不支持data声明
resource "huaweicloud_vpc_address_group" "address_group_test" {
  name = "address_group_test"
  addresses = [
    "192.168.10.12",
    "192.168.11.0-192.168.11.240"
  ]
}

resource "huaweicloud_networking_secgroup_rule" "secgroup_rules_test_2" {
  security_group_id       = huaweicloud_networking_secgroup.secgroup_test.id
  direction               = "ingress"
  ethertype               = "IPv4"
  protocol                = "tcp"
  ports                   = "80,500,600-800"
  remote_address_group_id = huaweicloud_vpc_address_group.address_group_test.id
  # remote_group_id = huaweicloud_networking_secgroup.secgroup_test.id //源端地址支持IP段、IP地址组、安全组
}
