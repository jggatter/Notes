## Creating an admin-level IAM identity
Safe to have instead of using root user.
On the IAM dashboard, there is an "AWS Account" table with account information which includes an Account Alias and a "Sign-in URL for IAM users".

For the Account Alias, you can set it to a string that is friendlier for login but still has a clear indication of which account it is. For the general account, set your Preferred Alias to something that contains "general".

In Users, click Add Users and give it a username like "iamadmin" or "general-admin". You will have options to create access keys for programmatic access and a password that can allow users to sign-in to the AWS Management Console. We'll go with the latter option for now and choose to customize it and record it. Uncheck "require password reset".

Next, it will prompt to set permissions. We will choose to "Attach existing policies directly" and give it `AdministratorAccess`. Confirming will create the user.

At the IAM dashboard, we will test logging into the admin user with the "Sign-in URL for IAM users" which we will use for the rest of the course. Go to the URL, you will be logged out of the root user and will have to log in as the admin user by entering the account ID number/alias and the IAM user password. Once logged in, the top-right account dropdown should show you are logged in as an IAM user.

We need to set up MFA for this account by going to Security Credentials. Assign MFA virtual device as a new entry (new QR code).

Repeat this process for the production AWS account.

## IAM Access Keys

IAM access keys are used for authenticating with AWS programmatically via the CLI or APIs.  They are long-term credentials, not changing automatically or regularly and requiring explicit updates. An IAM user has 1 username and optionally 1 password, but can have up to two sets of access keys. Access keys can be created, deleted, made inactive, or made active.

Each access key is composed of a Access Key ID, e.g. "AKIAIOSFODNN7EXAMPLE", and a Secret Access Key, e.g. "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY". This pair of values are analogous to a user name and password. You are only shown the Secret Access Key once, it will never be able to be regenerated or shown to you by AWS. You would have to delete the set and generate a new set. You can rotate them in this way.

IAM users are the only users that use access keys. Root user can technically have them too, but strongly disadvised. Roles do not use access keys.