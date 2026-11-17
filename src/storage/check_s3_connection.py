
import os
import sys

import boto3
from botocore.exceptions import BotoCoreError, ClientError


PROFILE = "grand-paris-dev"
REGION = "eu-north-1"
OBJECT_KEY = "bronze/s3-smoke-test.json"


def main():
    bucket = os.environ.get("GPM_S3_BUCKET")

    if not bucket:
        print("ERROR: GPM_S3_BUCKET is not defined.")
        return 1

    try:
        session = boto3.Session(
            profile_name=PROFILE,
            region_name=REGION,
        )

        s3 = session.client("s3")

        response = s3.head_object(
            Bucket=bucket,
            Key=OBJECT_KEY,
        )

    except (BotoCoreError, ClientError) as error:
        print(f"ERROR: {error}", file=sys.stderr)
        return 1

    size = response["ContentLength"]
    content_type = response["ContentType"]

    print(f"Object: {OBJECT_KEY}")
    print(f"Size: {size} bytes")
    print(f"Content-Type: {content_type}")

    if size == 141 and content_type == "application/json":
        print("RESULT: PASS")
        return 0

    print("RESULT: FAIL - Unexpected metadata")
    return 1


if __name__ == "__main__":
    sys.exit(main())
