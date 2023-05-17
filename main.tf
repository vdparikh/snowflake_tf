terraform {
  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "~> 0.59"
    }
  }
}

provider "snowflake" {
  role  = "SYSADMIN"
}

resource "snowflake_database" "db" {
  name     = "SECURITY_DATA_LAKE"
}

resource "snowflake_warehouse" "warehouse" {
  name           = "SDL_WH"
  warehouse_size = "xsmall"
  enable_query_acceleration = false
  query_acceleration_max_scale_factor = 0
  auto_suspend = 60
}
