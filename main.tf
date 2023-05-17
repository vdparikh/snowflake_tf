resource "snowflake_database" "db" {
  name     = "SECURITY_DATA_LAKE"
  comment = "Demo database for security data lake"

}


resource "snowflake_schema" "schema" {
    database   = snowflake_database.db.name
    name       = "SDL"
    is_managed = false
}

resource "snowflake_warehouse" "warehouse" {
  name           = "SDL_WH"
  warehouse_size = "xsmall"
  enable_query_acceleration = false
  query_acceleration_max_scale_factor = 0
  auto_suspend = 60
}

