# to get canonical name
aws s3api list-buckets
{
    "Owner": {
        "DisplayName": "owner",
        "ID": "cfa2b85172917f2a2f4e50040d2b6ab63770e70b995dcbe787c8ceb350708aac"
    },
...
# policy itself
{
    "Id": "Policy1519815897918",
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Stmt1519815367664",
            "Action": "s3:*",
            "Effect": "Allow",
            "Resource": "arn:aws:s3:::mybucket/*",
            "Principal": {
                "CanonicalUser": "01b2fc158a02666bfb1b56da6ad958d3b6fe8702540de3af517106f9aca37766"
            }
        }
    ]
}
