resource "aws_lambda_function" "html_lambda" {
  function_name    = local.lambda_name
  role             = aws_iam_role.lambda_role.arn
  handler          = var.lambda_index
  runtime          = var.lambda_runtime
  source_code_hash = data.archive_file.lambda_package.output_base64sha256
  timeout          = 30
  publish          = false
  tags             = var.tags
  architectures    = ["arm64"] #x86_64
  memory_size      = 512

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_object.lambda_handler_bucket_object.key

  depends_on = [
    aws_s3_object.lambda_handler_bucket_object,
  ]
}

resource "aws_cloudwatch_log_group" "html_loggroup_lambda" {
  name              = "/aws/lambda/${aws_lambda_function.html_lambda.function_name}"
  retention_in_days = 7
}
