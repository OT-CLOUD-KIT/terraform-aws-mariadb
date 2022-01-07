provider "aws" {
  region = var.primary_region
}

provider "aws" {
  alias  = "region2"
  region = var.secondry_region
}
