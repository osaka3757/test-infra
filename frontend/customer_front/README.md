## 課題

- terraform に変換
- 【済】CloudFront と WAF のリージョンはグローバル、S3 は東京リージョンで分割する

## ざっくり説明

- 静的ウェブサイトを S3 で使用して Web 公開できるように AWS リソースを作成できる
- CloudFunction で Basic 認証実装
- 同 IP から 5 分間に 100 回以上のアクセスがあった場合、制限かかります(WAFv2)
- OAC を使用して、CloudFront 経由でのみ S3 に格納した静的ウェブサイトにアクセスできます

## デプロイコマンド

```
# S3
aws cloudformation deploy `
--profile cds-stg `
--stack-name cds-customer-stg-front `
--template-file s3-template.yaml `
--parameter-overrides Env=stg ProjectName=cds `
--region ap-northeast-1 `
--no-fail-on-empty-changeset

# CloudFront/WAF
aws cloudformation deploy `
--profile cds-stg `
--stack-name cds-customer-stg-front `
--template-file template.yaml `
--parameter-overrides Env=stg ProjectName=cds `
--region us-east-1 `
--no-fail-on-empty-changeset
```
