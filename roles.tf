resource "snowflake_role" "role" {
    provider = snowflake.security_admin
    name     = "SDL_SVC_ROLE"
}

