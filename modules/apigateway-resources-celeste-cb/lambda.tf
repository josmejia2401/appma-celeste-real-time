resource "aws_lambda_function" "html_lambda" {
  filename         = data.archive_file.lambda_package.output_path
  function_name    = local.lambda_name
  role             = aws_iam_role.lambda_role.arn
  handler          = var.lambda_index
  runtime          = var.lambda_runtime
  source_code_hash = data.archive_file.lambda_package.output_base64sha256
  timeout          = 30
  publish          = false
  tags             = var.tags
  architectures    = ["x86_64"] #arm64
  memory_size      = 256
}

resource "aws_cloudwatch_log_group" "html_loggroup_lambda" {
  name = "/aws/lambda/${aws_lambda_function.html_lambda.function_name}"
}
