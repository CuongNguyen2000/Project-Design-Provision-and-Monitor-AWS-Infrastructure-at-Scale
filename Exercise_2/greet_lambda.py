import os

def lambda_handler(event, context):
    print("Lambda function executed successfully.")
    return "{} from Lambda!".format(os.environ['greeting'])
