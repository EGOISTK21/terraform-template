data "huaweicloud_images_image" "centos_7_9_x86" {
  architecture = "x86"
  os_version   = "CentOS 7.9 64bit"
  name         = "CentOS 7.9 64bit"
  visibility   = "public"
  most_recent  = true
}

data "huaweicloud_images_image" "centos_7_9_x86_sdi_5_1" {
  architecture = "x86"
  os_version   = "CentOS 7.9 64bit"
  name         = "CentOS 7.9 x86 64bit sdi5 for ECS Baremetal With Uniagent"
  visibility   = "public"
  most_recent  = true
}

data "huaweicloud_vpc_subnet" "subnet_test" {
  name = "subnet_test"
}

data "huaweicloud_networking_secgroup" "secgroup_test" {
  name = "secgroup_test"
}

resource "huaweicloud_vpc_eip" "eip_test" {
  publicip {
    type = "5_bgp"
  }

  bandwidth {
    share_type  = "PER"
    name        = "test"
    size        = 5
    charge_mode = "bandwidth"
  }
}

resource "huaweicloud_evs_volume" "volume_test" {
  name                 = "data"
  volume_type          = "SSD"
  size                 = 1000
  availability_zone    = "cn-east-3a"
  dedicated_storage_id = ""
}

resource "huaweicloud_compute_volume_attach" "volume_attach_test" {
  instance_id = huaweicloud_compute_instance.ecs_test.id
  volume_id   = huaweicloud_evs_volume.volume_test.id
}

resource "huaweicloud_compute_instance" "ecs_test" {
  name               = "ecs_with_data_volume"
  flavor_id          = "c7.16xlarge.4"
  image_id           = data.huaweicloud_images_image.centos_7_9_x86.id
  security_group_ids = [data.huaweicloud_networking_secgroup.secgroup_test.id]
  availability_zone  = "cn-east-3a"
  network {
    uuid = data.huaweicloud_vpc_subnet.subnet_test.id
  }
  admin_pass              = ""
  system_disk_type        = "SSD"
  system_disk_size        = 100
  system_disk_dss_pool_id = ""
  eip_id                  = huaweicloud_vpc_eip.eip_test.id
  charging_mode           = "postPaid"
}

resource "huaweicloud_networking_vip" "vip_test" {
  network_id = data.huaweicloud_vpc_subnet.subnet_test.id
}

resource "huaweicloud_networking_vip_associate" "vip_associate_test" {
  vip_id = huaweicloud_networking_vip.vip_test.id
  port_ids = huaweicloud_compute_instance.ecs_test_with_vip[*].network[0].port
}

resource "huaweicloud_compute_instance" "ecs_test_with_vip" {
  count              = 2
  name               = "ecs_with_vip_${count.index}"
  flavor_id          = "c7.16xlarge.4"
  image_id           = data.huaweicloud_images_image.centos_7_9_x86.id
  security_group_ids = [data.huaweicloud_networking_secgroup.secgroup_test.id]
  availability_zone  = "cn-east-3a"
  network {
    uuid = data.huaweicloud_vpc_subnet.subnet_test.id
    source_dest_check = false
  }
  admin_pass              = ""
  system_disk_type        = "SSD"
  system_disk_size        = 100
  system_disk_dss_pool_id = ""
  eip_id                  = huaweicloud_vpc_eip.eip_test.id
  charging_mode           = "postPaid"
}
