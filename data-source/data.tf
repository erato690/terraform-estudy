data "terraform_remote_state" "remote_state"{

    backend = "s3"
    config = {
        bucket = "tfstate-remote-state-${var.env}"
        key = "dev/terraform-data-source-exemple/terraform.tfstate"
        region = var.aws_region
        profile = var.aws_profile
    }
}

