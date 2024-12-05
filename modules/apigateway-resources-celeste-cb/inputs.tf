variable "env" {
  description = "Ambiente donde será desplegado el componente. dev, qa y pdn"
  type        = string
  validation {
    condition     = contains(["dev", "qa", "pdn"], var.env)
    error_message = "El ambiente no es válido"
  }
  nullable = false
  default  = "dev"
}

variable "app_name" {
  description = "Nombre de la aplicación: celeste-cb"
  type        = string
  nullable    = false
  default     = "celeste-cb"
}

variable "domain" {
  description = "Dominio o unidad de negocio al cual pertenece el componente"
  type        = string
  validation {
    condition     = contains(["security", "projects", "functionalities", "tasks", "transversal", "ia"], var.domain)
    error_message = "El dominio no es válido"
  }
  nullable = false
  default  = "ia"
}

variable "lambda_index" {
  description = "Ubicación del lambda_handler"
  type        = string
  nullable    = false
  default     = "index.lambda_handler"
}


variable "environment_variables" {
  description = "Variables de entorno de la lambda"
  type        = map(string)
  nullable    = true
  default = {
    ENVIRONMENT      = "dev"
    LOGGER_LEVEL     = "DEBUG"
    REGION           = "us-east-1"
    APP_NAME         = "celeste-cb"
    JTW_SECRET_VALUE = "secret"
    JWT_TOKEN_LIFE   = "365d"
  }
}

# https://docs.aws.amazon.com/lambda/latest/dg/lambda-runtimes.html
variable "lambda_runtime" {
  description = "Config runtime de la lambda"
  type        = string
  validation {
    condition     = contains(["python3.12"], var.lambda_runtime)
    error_message = "Runtime no es válido. Ver más https://docs.aws.amazon.com/lambda/latest/dg/lambda-runtimes.html"
  }
  nullable = false
  default  = "python3.12"
}


variable "tags" {
  description = "Tags para el recurso a crear"
  type        = map(string)
  nullable    = true
  default = {
    domain    = "core"
    component = "celeste-ch"
    env       = "dev"
  }
}


variable "api_id" {
  description = "ID de la API Gateway"
  type        = string
  nullable    = false
  default     = "bup57xeb9i"
}


variable "authorizer_id" {
  description = "ID de la authorizer"
  type        = string
  nullable    = false
  default     = "bup57xeb9i"
}

