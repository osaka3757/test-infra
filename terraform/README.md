## 課題

- README.md の整理
- tflint 入れたい
- tfsec 入れたい
- terraform-docs 入れたい
- terraform-j2md みたいなの入れたい
- VSCode に vscode-terraform をインストールしたら自動フォーマットかかるようにする
- terraform plan 時に AWS リソースで使用しない変数をアップロードしていると Warning が出ているので解消すること

## ディレクトリ構成　※整理中

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

- AWS CLI をインストール
- AWS プロファイルを設定
- AWS プロファイルに MFA 設定を追加
- terraform-variables.tf の project_name を修正する
- CodeStar Connection 作成後に手動で AWS コンソール Codepipeline 設定 接続から GitHub の認証を行う必要がある(初回のみ)
  - [GitHub 認証の参考サイト](https://zenn.dev/taroman_zenn/articles/4007a33384c6ad)

## 環境構築　※整理中

- 環境名は dev/stg/prd を 3 環境を想定しています
- backend の key の値を変更する必要がある

1. Terraform の State 管理用バックエンド作成(初回のみ)

```
cd ~/shared

# 環境名とプロジェクト名を変更すること
aws cloudformation deploy `
--profile プロファイル名 `
--stack-name プロジェクト名-環境名-terraform-backend `
--template-file terraform-backend.yaml `
--parameter-overrides Env=環境名 ProjectName=プロジェクト名 `
--region ap-northeast-1 `
--no-fail-on-empty-changeset
```

2. 必要な AWS リソースを作成

```
## ここもbatファイルにまとめる
cd ~/category/AWSアカウント/プロジェクト
terraform init -reconfigure -backend-config="../.env/dev.tfvars"
terraform init -reconfigure -backend-config="../.env/stg.tfvars"

# plan
cd ~/terraform
./wrap-tf-cmd.bat plan cds stg category/cds/infra cds-stg
./wrap-tf-cmd.bat plan cds stg category/cds/customer_back cds-stg
./wrap-tf-cmd.bat plan cds stg category/cds/account_manage_back cds-stg

# apply
./wrap-tf-cmd.bat apply cds stg category/cds/infra cds-stg
./wrap-tf-cmd.bat apply cds stg category/cds/customer_back cds-stg
./wrap-tf-cmd.bat apply cds stg category/cds/account_manage_back cds-stg

# destroy(全てのAWSリソースを削除したい場合に実行する)
./wrap-tf-cmd.bat destroy cds stg category/cds/infra cds-stg
./wrap-tf-cmd.bat destroy cds stg category/cds/customer_back cds-stg
./wrap-tf-cmd.bat destroy cds stg category/cds/account_manage_back cds-stg

```

### コマンド退避場所

rem 引数説明
rem %1=terraform コマンド(plan/apply)
rem %2=プロジェクト名
rem %3=環境名(prd/stg/dev/person)
rem %4=terraform 実行ファイルがあるディレクトリ
rem %5=プロファイル名

aws cloudformation deploy `--profile cds-stg`
--stack-name cds-stg-terraform-backend `--template-file terraform-backend.yaml`
--parameter-overrides Env=stg ProjectName=cds `--region ap-northeast-1`
--no-fail-on-empty-changeset
