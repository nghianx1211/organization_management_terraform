resource "aws_iam_role" "put_get_s3" {
  name = "aws_iam_role"
  assume_role_policy = var.ec2_assume_role_policy_document

  tags = {
    Name = "ec_put_get_s3_role"
  }
}

resource "aws_iam_role_policy_attachment" "role" {
  policy_arn = var.ec2_put_get_s3_policy_arn
  role = aws_iam_role.put_get_s3.name
}