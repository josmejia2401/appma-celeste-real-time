data "aws_apigatewayv2_api" "selected" {
  #name   = local.api_name
  api_id = var.api_id
}

# automaticamente crea el zip con todo lo que haya en el directorio
data "archive_file" "lambda_package" {
  type        = "zip"
  source_dir  = "${path.root}/lambdas/core/celeste-cb"
  output_path = "${path.root}/resources/core/celeste-cb/index.zip"
}

data "aws_caller_identity" "current" {

}

data "aws_region" "current" {

}


# Data source to check if the S3 bucket exists
data "aws_s3_bucket" "existing_bucket" {
  bucket = "bucket-appma-lambda-target-${var.env}"
}