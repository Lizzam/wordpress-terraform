# data "aws_availability_zones" "availability_zones" {}

# resource "aws_subnet" "subnet" {
#     count = "${length(data.aws_availability_zones.availability_zones.names)}"

#     vpc_id = "${aws_vpc.wp.id}"
#     availability_zone = "${element(data.aws_availability_zones.availability_zones.names, count.index)}"
#     cidr_block = "${element(var.subnet_cidr,count.index)}"

#     tags = {
#         Name = "subnet-${count.index + 1}"
#     }
# }