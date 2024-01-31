environment = "estudo"
vpc_cidr = "10.0.0.0/16"
subnet_cidr = {
    "public": {
        name: "public",
        cidr_block: "10.0.1.0/24",
    },
    "private": {
        name: "private",
        cidr_block: "10.0.2.0/24",
    },
    "mgmt": {
        name: "mgmt",
        cidr_block: "10.0.3.0/24",
    }
}
my_cidr = "168.196.137.40/32" 