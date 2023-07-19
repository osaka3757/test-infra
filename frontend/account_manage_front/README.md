## 課題
- terraformに変換
- CloudFrontとWAFのリージョンはグローバル、S3は東京リージョンで分割する

## ざっくり説明
- 静的ウェブサイトをS3で使用してWeb公開できるようにAWSリソースを作成できる
- CloudFunctionでBasic認証実装
- 同IPから5分間に100回以上のアクセスがあった場合、制限かかります(WAFv2)
- OACを使用して、CloudFront経由でのみS3に格納した静的ウェブサイトにアクセスできます

## デプロイコマンド
```
# S3
aws cloudformation deploy `
--profile cds-stg `
--stack-name cds-account-manage-stg-front `
--template-file s3-template.yaml `
--parameter-overrides Env=stg ProjectName=cds `
--region ap-northeast-1 `
--no-fail-on-empty-changeset

# CloudFront/WAF
aws cloudformation deploy `
--profile cds-stg `
--stack-name cds-account-manage-stg-front `
--template-file template.yaml `
--parameter-overrides Env=stg ProjectName=cds `
--region us-east-1 `
--no-fail-on-empty-changeset
```