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
    key     = "cds/infra/terraform.tfstate"
    encrypt = true
  }
}

provider "aws" {
  region  = "ap-northeast-1"
  profile = var.profile
}

module "vpc" {
  source     = "../../../modules/vpc"
  prefix     = "${var.env}-${var.project_name}"
  cidr_block = "10.0.0.0/16"
}

module "igw" {
  source = "../../../modules/internet_gateway"
  prefix = "${var.env}-${var.project_name}"
  vpc_id = module.vpc.vpc_id
}

module "public_rtb" {
  source = "../../../modules/public_route_table"
  prefix = "${var.env}-${var.project_name}"
  vpc_id = module.vpc.vpc_id
  igw_id = module.igw.igw_id
}

module "private_rtb" {
  source = "../../../modules/private_route_table"
  prefix = "${var.env}-${var.project_name}"
  vpc_id = module.vpc.vpc_id
}

module "public_subnet_1a" {
  source        = "../../../modules/public_subnet_1a"
  prefix        = "${var.env}-${var.project_name}"
  vpc_id        = module.vpc.vpc_id
  cidr_block    = "10.0.1.0/24"
  public_rtb_id = module.public_rtb.public_rtb_id
}

module "public_subnet_1c" {
  source        = "../../../modules/public_subnet_1c"
  prefix        = "${var.env}-${var.project_name}"
  vpc_id        = module.vpc.vpc_id
  cidr_block    = "10.0.2.0/24"
  public_rtb_id = module.public_rtb.public_rtb_id
}

module "private_subnet_1a" {
  source         = "../../../modules/private_subnet_1a"
  prefix         = "${var.env}-${var.project_name}"
  vpc_id         = module.vpc.vpc_id
  cidr_block     = "10.0.11.0/24"
  private_rtb_id = module.private_rtb.private_rtb_id
}


module "private_subnet_1c" {
  source         = "../../../modules/private_subnet_1c"
  prefix         = "${var.env}-${var.project_name}"
  vpc_id         = module.vpc.vpc_id
  cidr_block     = "10.0.12.0/24"
  private_rtb_id = module.private_rtb.private_rtb_id
}
