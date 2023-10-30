# TODO: Define the output variable for the lambda function.
output "lambda_function_arn" {
  description = "The ARN of the deployed Lambda function."
  value       = aws_lambda_function.example_lambda.arn
}
