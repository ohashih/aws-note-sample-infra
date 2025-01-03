# AWS CLIを使用して、先行して必要なリソースを立ち上げる

## Dynamo DB

下記はオンデマンドキャパシティの例

```shell
$ aws dynamodb \
  create-table \
  --attribute-definitions="[{\"AttributeName\": \"LockID\",\"AttributeType\": \"S\"}]" --table-name "aws-note-sample-infra" --key-schema "[{\"AttributeName\": \"LockID\", \"KeyType\": \"HASH\"}]" \
  --billing-mode PAY_PER_REQUEST
```

## S3

```shell
$ aws s3 mb \
  s3://kurage-mb-test
```
