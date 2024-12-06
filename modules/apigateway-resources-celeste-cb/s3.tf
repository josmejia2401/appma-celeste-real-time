#resource "random_pet" "lambda_bucket_name" {
#  prefix = "bucket-appma"
#  length = 4
#}
#resource "aws_s3_bucket" "lambda_bucket" {
#  bucket = random_pet.lambda_bucket_name.id
#}

resource "aws_s3_bucket" "lambda_bucket" {
  #count         = length(data.aws_s3_bucket.existing_bucket.id) == 0 ? 1 : 0
  bucket        = "bucket-appma-lambda-target-${var.env}"
  force_destroy = true
  tags = {
    Name        = "bucket-appma-lambda-target-${var.env}"
    Environment = "${var.env}"
  }
}

resource "aws_s3_bucket_ownership_controls" "lambda_bucket_ownership_controls" {
  bucket = aws_s3_bucket.lambda_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "lambda_bucket_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.lambda_bucket_ownership_controls]
  bucket     = aws_s3_bucket.lambda_bucket.id
  acl        = "private"
}

resource "aws_s3_object" "lambda_handler_bucket_object" {
  bucket = aws_s3_bucket.lambda_bucket.id
  key    = "handler.zip"
  source = data.archive_file.lambda_package.output_path
  etag   = filemd5(data.archive_file.lambda_package.output_path)
  depends_on = [
    data.archive_file.lambda_package,
  ]
}
