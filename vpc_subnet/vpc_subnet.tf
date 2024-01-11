resource "huaweicloud_vpc" "vpc_1" {
  name = "vpc_1"
  cidr = "10.23.255.0/24"

}

resource "huaweicloud_vpc_subnet" "subnet_1" {
  name       = "subnet_1"
  cidr       = "10.23.255.128/25"
  gateway_ip = "10.23.255.129"
  dns_list   = ["100.125.251.250", "114.114.114.114"]
  vpc_id     = huaweicloud_vpc.vpc_1.id
}
