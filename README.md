Demonstration repo to manage Snowflake account using Terraform

## Snowflake Account Setup
Let's start with Snowflake setup. 

1. Get your [free snowflake account](https://signup.snowflake.com/) which provides a 30 day trial and $400 worth of free usage. Once you activate your free account, you will get an email with your username and dedicated login URL

```text
Username: VDPARIKH
Dedicated Login URL: https://xebjdqb-xab93309.snowflakecomputing.com
```

2. Rather than using your admin username/password, We will be creating a user using public/private keys for authentication. 

```shell
cd ~/.ssh
openssl genrsa 2048 | openssl pkcs8 -topk8 -inform PEM -out sdl_user_rsa_key.p8 -nocrypt
openssl rsa -in sdl_user_rsa_key.p8 -pubout -out sdl_user_rsa_key.pub


openssl genrsa -out snowflake_key 4096
openssl rsa -in snowflake_key -pubout -out snowflake_key.pub
```

3. Go to your dedicated Snowflake URL and create a new worksheet. Here we will be creating a new service user and assigning the public key to it. Please note that the public key is without the `BEGIN PUBLIC KEY` header and `END PUBLIC KEY` footer.

```sql
USE ROLE ACCOUNTADMIN;

-- Create new user with the public key
CREATE USER "sdl-user" RSA_PUBLIC_KEY='MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEApwE+2C/3W8cw7OYtMAGg
sscjB2u0kWv2PKrQRI5b9JqazThi4fclQKTiwsRVvgYFyskyoKPunK8Bmy+DJ5p6
zjyGEXZye2U/2bBMxNhi4NQrvC8TESlaxhXB4GkXKaF9lrgLyVvLPWM86rwgTYHf
/9wbIsSjIoCvUYkm0jx14QDhgDG7q6fbB18z+S4m5cBLQuI+xo51pHqJJc6HUoPW
WMocWk2V1vF5iwMHPtE1gI478c6bWvOVewrpxtNXJ+Wz5Z8BWUu/B+6JwWyFcU7N
/Q1bWsCEXCAmWcGXG0pUlWFZeL8aobB+TdyFN0Y3wmfSgaYA6RWgMPE0r0x6nCYO
XwIDAQAB' DEFAULT_ROLE=PUBLIC MUST_CHANGE_PASSWORD=FALSE;

-- Grant sysadmin and securityadmin role to the user
GRANT ROLE SYSADMIN TO USER "sdl-user";
GRANT ROLE SECURITYADMIN TO USER "sdl-user";

-- Give Grants to operate on the warehouse 
GRANT OPERATE ON WAREHOUSE compute_wh TO ROLE SYSADMIN WITH GRANT OPTION;
```
{{< notice warning >}}
We grant the user SYSADMIN and SECURITYADMIN privileges to keep the lab simple. An important security best practice, however, is to limit all user accounts to least-privilege access. In a production environment, this key should also be secured with a secrets management solution like Hashicorp Vault, Azure Key Vault, or AWS Secrets Manager.
{{< /notice >}}


4. Install [SnowSQL](https://docs.snowflake.com/en/user-guide/snowsql) - SnowSQL is the command line client for connecting to Snowflake to execute SQL queries and perform all DDL and DML operations, including loading data into and unloading data out of database tables. Upon installing the package, you will see instructions on how to execute it


>	1.	Open a new terminal window.
>	2.	Execute the following command to test your connection:snowsql -a <account_name> -u <login_name>Enter your password when prompted. Enter !quit to quit the connection. 
>	3.	Add your connection information to the ~/.snowsql/config file:accountname = <account_name>username = <user_name>password = <password> 
>	4.	Execute the following command to connect to Snowflake:snowsqlor double click the SnowSQL application icon in the Applications directory. 



```shell
~/.snowsql/1.2.26/snowsql -a xebjdqb-xab93309 -u sdl-user --private-key-path ~/.ssh/sdl_user_rsa_key.p8
```

5. Get your account ID and region from Snowflake using SnowSQL
```shell
~/.snowsql/1.2.26/snowsql -a xebjdqb-xab93309 -u sdl-user --private-key-path ~/.ssh/sdl_user_rsa_key.p8 
sdl-user#(no warehouse)@SNOWFLAKE.(no schema)>SELECT current_account() as YOUR_ACCOUNT_LOCATOR, current_region() as YOUR_SNOWFLAKE_REGION_ID;
+----------------------+--------------------------+                             
| YOUR_ACCOUNT_LOCATOR | YOUR_SNOWFLAKE_REGION_ID |
|----------------------+--------------------------|
| YZB33825             | AWS_US_WEST_2            |
+----------------------+--------------------------+
1 Row(s) produced. Time Elapsed: 0.407s
```

6. We will be using Terraform https://github.com/JimMcKenzieSmith/managing-snowflake-objects-with-terraform to manage AWS and Snowflake objects. Let's get that going - Create environment variables for Terraform to use

```shell
export SNOWFLAKE_USER="sdl-user"
export SNOWFLAKE_PRIVATE_KEY_PATH="~/.ssh/sdl_user_rsa_key.p8"
export SNOWFLAKE_ACCOUNT="yzb33825"
export SNOWFLAKE_REGION="us-west-2"
```

Let's created a new directory to store out terraform files
```shell
cd ~/go/src/github.com/vdparikh
mkdir snowflake_tf
cd snowflake_tf
```

and create a new file call `main.tf`. You can copy the contents from the github repo or clone it

Run the following from a shell in your project folder:
```
terraform init
```

Plan and apply changes
```
terraform plan
terraform apply
```

This will create a new database and warehouse on your snowflake account