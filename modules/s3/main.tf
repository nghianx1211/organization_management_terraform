resource "aws_s3_bucket" "s3_buckets" {
    for_each = var.s3_buckets

    bucket = each.value

    tags = {
        "Name" = "${var.project_name}-${var.env}-${each.value}"
    }
}