resource "snowflake_database_grant" "grant" {
    provider          = snowflake.security_admin
    database_name     = snowflake_database.db.name
    privilege         = "USAGE"
    roles             = [snowflake_role.role.name]
    with_grant_option = false
}

resource "snowflake_schema_grant" "grant" {
    provider          = snowflake.security_admin
    database_name     = snowflake_database.db.name
    schema_name       = snowflake_schema.schema.name
    privilege         = "USAGE"
    roles             = [snowflake_role.role.name]
    with_grant_option = false
}

resource "snowflake_warehouse_grant" "grant" {
    provider          = snowflake.security_admin
    warehouse_name    = snowflake_warehouse.warehouse.name
    privilege         = "USAGE"
    roles             = [snowflake_role.role.name]
    with_grant_option = false
}
