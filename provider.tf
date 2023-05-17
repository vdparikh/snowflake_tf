terraform {
  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "~> 0.59"
    }
  }
}

provider "snowflake" {
  role = "SYSADMIN"
}

provider "snowflake" {
   alias    = "security_admin"
   role     = "SECURITYADMIN"
}
