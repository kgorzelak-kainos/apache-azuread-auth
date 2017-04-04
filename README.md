# apache-azuread-auth
Docker Container with Apache ModProxy + AzureAD Auth (OpenID)

This is a tutorial (+code) on how to setup the AzureAD authentication and authorisation (group membership check) in Apache. This setup can be use to restrict to access local webpage/file (on apache server) or to remote resources (using mod_proxy). For example: http://rundeck.org/docs/administration/authenticating-users.html#preauthenticated-mode

# Software / technologies were used:
- docker
- docker-compose
- ubuntu
- apache
- apache-mod-proxy
- mod_auth_openidc https://github.com/pingidentity/mod_auth_openidc
- azure ad https://apps.dev.microsoft.com/#/appList

# Setup

The following environment variables needs to be set to make this work (in the .env file):

1) TenantID - you will find this in the https://portal.azure.com (Dashboard > Azure Active Directory > Manage / Properties > Directory ID
2) OIDCClientSecret - you will get it from the Application Registration Portal (https://apps.dev.microsoft.com/#/appList)
3) OIDCClientID - you will get it from the Application Registration Portal (https://apps.dev.microsoft.com/#/appList)
4) OIDCCryptoPassphrase - long random string to encrypt the session

# Lessons learned:

1) You need to register you app using the new Application Registration Portal (https://apps.dev.microsoft.com/#/appList). The traditional way (using https://portal.azure.com) will not work for oAuth 2.0. More about this you can find here: https://docs.microsoft.com/en-us/azure/active-directory/develop/active-directory-v2-limitations

2) You need to modify by hand the application manifest file (using the Application Registration Portal) to enable sending the  groups membership information in the claims. You simple need to set the attribute "groupMembershipClaims" to value "All" or "SecurityGroup". More about this you can find here: https://www.simple-talk.com/cloud/security-and-compliance/azure-active-directory-part-4-group-claims/

3) The groups membership information will be only send (in claims) if you set the response mode to "POST" (the default mode is GET).  You set this in the mod_auth_openidc configuration file (OIDCResponseMode "form_post").

4) The groups membership information (in claims) only contains groups object_ids (not group names). You can easy lookup those (ids) using the https://portal.azure.com .

5) The claims are set also in the apache request environment variables however you will not be probably able to use them in the apache "if statements" (like setenvif) as they are set too late for that. 


