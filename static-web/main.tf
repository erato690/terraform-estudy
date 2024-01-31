module "bucket" {
    source  = "../S3_module"
    name    = "static-web-site-estudo-terraform"
    tags = {
        Name = "static-web"
    }
    key_prefix = "static-web"
    files = "./../static-web-site-files/"
    policy = data.template_file.policy.rendered
}