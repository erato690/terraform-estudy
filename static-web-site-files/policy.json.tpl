{
    "Id": "Policy",
    "Statement": [
      {
        "Action": [
          "s3:GetObject"
        ],
        "Effect": "Allow",
        "Resource": "arn:aws:s3:::${bucket_name}/*",
        "Principal": {
          "AWS": [
            "*"
          ]
        }
      }
    ]
}