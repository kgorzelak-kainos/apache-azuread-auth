# apache-azuread-auth
Docker Container with Apache ModProxy + AzureAD Auth (OpenID)

This is a tutorial (+code) on how to setup the AzureAD authentication and authorisation (group membership check) in Apache. This setup can be use to restrict to access local webpage/file (on apache server) or to remote resources (using mod_proxy). For example: http://rundeck.org/docs/administration/authenticating-users.html#preauthenticated-mode

# The following software / technologies were used:
- docker
- docker-compose
- ubuntu
- apache
- apache-mod-proxy
- mod_auth_openidc https://github.com/pingidentity/mod_auth_openidc
- azure ad https://apps.dev.microsoft.com/#/appList

# Lessons learned:
