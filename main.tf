terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      iac = "terraform"
    }
  }
  #access_key = "my-access-key"
  #secret_key = "my-secret-key"
}



####################
# DYNAMO
####################
module "sessions_dynamodb" {
  source = "./modules/sessions-dynamodb"
}

####################
# API GATEWAY
####################
module "api_gateway" {
  source = "./modules/apigateway"
}

####################
# API GATEWAY RESOURCES
####################

module "api_gateway_resources_celeste_cb" {
  source = "./modules/apigateway-resources-celeste-cb"
  api_id = module.api_gateway.api_id # < output of module.api_gateway
  depends_on = [
    module.api_gateway,
    module.sessions_dynamodb
  ]
}

module "api_gateway_resources_real_time" {
  source = "./modules/apigateway-resources-celeste-real-time"
  api_id = module.api_gateway.api_id # < output of module.api_gateway
  depends_on = [
    module.api_gateway,
    module.sessions_dynamodb
  ]
}