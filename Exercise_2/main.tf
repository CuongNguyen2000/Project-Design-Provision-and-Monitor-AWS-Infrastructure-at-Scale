provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.region
}

resource "aws_iam_role" "lambda_execution_role" {
  name = "lambda_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "lambda_execution_policy" {
  name        = "lambda_execution_policy"
  description = "Policy for Lambda execution role"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Effect   = "Allow",
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_iam_role_policy_attachment" {
  policy_arn = aws_iam_policy.lambda_execution_policy.arn
  role       = aws_iam_role.lambda_execution_role.name
}

resource "aws_cloudwatch_log_group" "lambda_logs" {
  name              = "/aws/lambda/${var.lambda_name}"
  retention_in_days = 7 # Adjust the retention period as needed
}

data "archive_file" "lambda" {
  type        = "zip"
  source_file = "greet_lambda.py"
  output_path = var.lambda_output_path
}

resource "aws_lambda_function" "example_lambda" {
  function_name    = var.lambda_name
  handler          = "lambda.lambda_handler"
  runtime          = "python3.8"
  role             = aws_iam_role.lambda_execution_role.arn
  filename         = data.archive_file.lambda.output_path
  source_code_hash = filebase64sha256(data.archive_file.lambda.output_path)
  depends_on       = [aws_iam_role_policy_attachment.lambda_iam_role_policy_attachment, aws_cloudwatch_log_group.lambda_logs]

  environment {
    variables = {
      greeting = "Hello World!"
    }
  }
}
