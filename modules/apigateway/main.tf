resource "aws_apigatewayv2_api" "main" {
  name                       = local.api_name
  protocol_type              = "WEBSOCKET"
  description                = "${local.api_name} API Gateway"
  route_selection_expression = "$request.body.action"
}

resource "aws_apigatewayv2_stage" "dev" {
  api_id = aws_apigatewayv2_api.main.id

  name        = var.env
  auto_deploy = true

  default_route_settings {
    throttling_burst_limit = 50
    throttling_rate_limit  = 100
  }
}
