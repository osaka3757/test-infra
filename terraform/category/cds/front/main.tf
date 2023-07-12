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
    key     = "cds/frontend/terraform.tfstate"
    encrypt = true
  }
}

provider "aws" {
  region  = "ap-northeast-1"
  profile = var.profile
}

module "s3" {
  source            = "../../../modules/s3"
  count_of_resource = var.env == "prd" ? 1 : 0
  project_name      = var.project_name
  env               = var.env
}

module "frontend-codebuild" {
  source       = "../../../modules/frontend-codebuild"
  project_name = var.project_name
  env          = var.env
}

module "frontend-codepipeline" {
  source                   = "../../../modules/frontend-codepipeline"
  project_name             = var.project_name
  env                      = var.env
  frontend_repository_path = local.frontend_repository_path
  codebuild_name           = module.frontend-codebuild.codebuild_name
}
