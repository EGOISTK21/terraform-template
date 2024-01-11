data "huaweicloud_vpc" "vpc_1" {
  name = "vpc_1"
}

data "huaweicloud_vpc" "vpc_2" {
  name = "vpc_2"
}

resource "huaweicloud_vpc_peering_connection" "peering" {
  name        = "peering_test"
  vpc_id      = data.huaweicloud_vpc.vpc_1.id
  peer_vpc_id = data.huaweicloud_vpc.vpc_2.id
}

resource "huaweicloud_vpc_route" "vpc_route1" {
  vpc_id      = data.huaweicloud_vpc.vpc_1.id
  destination = "192.168.0.0/16"
  type        = "peering"
  nexthop     = huaweicloud_vpc_peering_connection.peering.id
}


resource "huaweicloud_vpc_route" "vpc_route2" {
  vpc_id      = data.huaweicloud_vpc.vpc_2.id
  destination = "10.23.255.0/24"
  type        = "peering"
  nexthop     = huaweicloud_vpc_peering_connection.peering.id
}
