terraform {
  required_version = "~> 1.5.1"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.4.0"
    }
  }

  backend "s3" {
    # stateファイルの保存先情報はenvフォルダ配下のtfvarsファイルに記入
    region  = "ap-northeast-1"
    key     = "infra/terraform.tfstate"
    encrypt = true
  }
}

provider "aws" {
  region  = "ap-northeast-1"
  profile = var.profile
}
