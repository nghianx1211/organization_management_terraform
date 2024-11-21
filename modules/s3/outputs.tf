output "s3_buckets_arns" {
  value = flatten([
    for s3_bucket in aws_s3_bucket.s3_buckets : [
      s3_bucket.arn,
      "${s3_bucket.arn}/*"
    ]
  ])
}
