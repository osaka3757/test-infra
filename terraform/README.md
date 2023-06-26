## 課題
- tflint入れたい
- tfsec入れたい
- terraform-docs入れたい
- terraform-j2mdみたいなの入れたい
- VSCodeにvscode-terraformをインストールしたら自動フォーマットかかるようにする
- terraform plan時にAWSリソースで使用しない変数をアップロードしているとWarningが出ているので解消すること

## ディレクトリ構成
```
.
├── .vscode
│   ├── extensions.json : VSCodeで使用をリコメンドするプラグインを定義します。
│   └── settings.json : 
├── frontend : 静的ウェブサイトをホスティングできるAWSリソースを作成。今後Terraform化するので詳細割愛。
│   ├── README.md
│   └── template.yaml 
└── terraform
    ├── enfironments : 各環境固有のAWSリソース作成ファイルや設定ファイルを格納する
    │   ├── dev
    │   │   ├── main.tf
    │   │   ├── variables.tf
    │   │   └── dev.tfvars : terraform init時に必要なState管理用バックエンド(S3&DynamoDB)の設定やAWSプロファイル名を格納する。ファイルは持っている人からもらうこと。
    │   ├── stg
    │   └── prd
    ├── modules : 汎用的に利用するモジュールを定義する
    │   ├── frontend-codebuild
    │   │   ├── main.tf
    │   │   ├── variables.tf
    │   │   └── outputs.tf
    │   ├── s3
    │   └── ...
    ├── shared : 共通のファイルや設定を定義する
    │   └── terraform-backend.yaml : TerraformのState管理用バックエンドを作成するCFn
    ├── .gitignore
    ├── README.md
    ├── main.tf : 全環境共通で作成するAWSリソースを定義する。環境ごとのAWSリソースの作成数の制御はここで行う。
    └── variables.tf

```

## 事前準備　※整理中
- AWS CLIをインストール
- AWS プロファイルを設定
- AWS プロファイルにMFA設定を追加
- terraform-variables.tfのproject_nameを修正する

## 環境構築
- 環境名の切り替えは、terraform workspaceで行います
- 環境名はdev/stg/prdを3環境を想定しています

1. TerraformのState管理用バックエンド作成(初回のみ)
```
cd ~/shared

# 環境名とプロジェクト名を変更すること
aws cloudformation deploy `
--profile プロファイル名 `
--stack-name 環境名-プロジェクト名-terraform-backend `
--template-file terraform-backend.yaml `
--parameter-overrides Env=環境名 ProjectName=プロジェクト名 `
--region ap-northeast-1 `
--no-fail-on-empty-changeset
```
2. environments配下の各環境フォルダにある「環境名.tfvars」の設定値を変更する(初回のみ)
3. 必要なAWSリソースを作成
```
cd ~/terraform

terraform init -reconfigure -backend-config="./environments/環境名/環境名.tfvars"

# 各環境の初回デプロイ時にのみ実行
terraform workspace new 環境名

terraform workspace select 環境名
terraform validate
terraform plan -var-file ./environments/環境名/環境名.tfvars -out 環境名-plan.tfplan

# plan結果をjson形式に変換(飛ばして良い)
terraform show -json plan.tfplan > plan.json 

terraform apply "環境名-plan.tfplan"

# 全てのAWSリソースを削除したい場合に実行する
terraform destroy
```
4. CodeStar Connection 作成後に手動で AWSコンソール Codepipeline 設定 接続から GitHub の認証を行う必要がある(初回のみ)
  - [GitHub認証の参考サイト](https://zenn.dev/taroman_zenn/articles/4007a33384c6ad)