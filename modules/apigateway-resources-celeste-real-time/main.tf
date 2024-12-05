resource "aws_apigatewayv2_integration" "lambda_handler" {
  api_id = data.aws_apigatewayv2_api.selected.id

  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.html_lambda.invoke_arn
  #connection_type    = "INTERNET"
  #integration_method = "ANY"
}

resource "aws_apigatewayv2_route" "ws_messenger_api_default_route" {
  api_id    = data.aws_apigatewayv2_api.selected.id
  route_key = "$default"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_handler.id}"
}

resource "aws_apigatewayv2_route_response" "ws_messenger_api_default_route_response" {
  api_id             = data.aws_apigatewayv2_api.selected.id
  route_id           = aws_apigatewayv2_route.ws_messenger_api_default_route.id
  route_response_key = "$default"
}

resource "aws_apigatewayv2_route" "ws_messenger_api_connect_route" {
  api_id    = data.aws_apigatewayv2_api.selected.id
  route_key = "$connect"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_handler.id}"
}

resource "aws_apigatewayv2_route_response" "ws_messenger_api_connect_route_response" {
  api_id             = data.aws_apigatewayv2_api.selected.id
  route_id           = aws_apigatewayv2_route.ws_messenger_api_connect_route.id
  route_response_key = "$default"
}

resource "aws_apigatewayv2_route" "ws_messenger_api_disconnect_route" {
  api_id    = data.aws_apigatewayv2_api.selected.id
  route_key = "$disconnect"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_handler.id}"
}

resource "aws_apigatewayv2_route_response" "ws_messenger_api_disconnect_route_response" {
  api_id             = data.aws_apigatewayv2_api.selected.id
  route_id           = aws_apigatewayv2_route.ws_messenger_api_disconnect_route.id
  route_response_key = "$default"
}

resource "aws_apigatewayv2_route" "ws_messenger_api_message_route" {
  api_id    = data.aws_apigatewayv2_api.selected.id
  route_key = "message"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_handler.id}"
}

resource "aws_apigatewayv2_route_response" "ws_messenger_api_message_route_response" {
  api_id             = data.aws_apigatewayv2_api.selected.id
  route_id           = aws_apigatewayv2_route.ws_messenger_api_message_route.id
  route_response_key = "$default"
}

resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.html_lambda.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${data.aws_apigatewayv2_api.selected.execution_arn}/*/*"
}
