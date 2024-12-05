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
    JWT_TOKEN_LIFE   = "1000"
  }
}

variable "tags" {
  description = "Tags para el recurso a crear"
  type        = map(string)
  nullable    = true
  default = {
    domain    = "transversal"
    component = "apigateway"
    env       = "dev"
  }
}
