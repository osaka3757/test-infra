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
aws cloudformation deploy `
--profile プロファイル名 `
--stack-name 環境名-プロジェクト名-frontend `
--template-file template.yaml `
--parameter-overrides Env=環境名 ProjectName=プロジェクト名 `
--region us-east-1 `
--no-fail-on-empty-changeset
```