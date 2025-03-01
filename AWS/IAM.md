# AWS IAM
#aws #iam #roles #users #policies #accounts 

IAM users vs. roles vs. policies

An IAM user is an identity with long-term credentials that is used to interact with AWS in an account.

An IAM role is an identity you can create that has specific permissions with credentials that are valid for short durations. Roles can be assumed by entities that you trust.

A policy is an object in AWS that defines permissions.

A user can be created with a new policy (`sts.AssumeRole`) which allows it to assume role(s)

## Basics

Identity and Access Management is a service running on all accounts.
IAM is a globally resilient service, any data is always secure across all AWS regions. 
The IAM running on an account is its own instance, separate from other accounts. 
There is full trust between your account and its IAM: like the root user, IAM can do anything in the account (with some restrictions around billing/account closure).
Inside IAM we can create different identities across different types of identities with explicitly granted permissions

### 3 different types of identity objects:
1. Users: humans or applications that need access to your account
2. Groups: collections of related users
3. Roles: Can be used by AWS services, or for granting external access to your account. For use by an uncertain number of entities (e.g. all EC2 instances). Allow services to act on your behalf.

### Policies
Policy documents are created through IAM. They allow or deny access to AWS services only when attached to IAM users, groups, or roles. On their own they do nothing.

### IAM has 3 main jobs
* **Manages identities** as an Identity Provider (IDP) - create, modify, and delete identities such as users and roles
* **Authenticates** those identities. When anyone attempts to make a request, they are known as a security principle that needs to prove their identity. IAM authenticates when given username/password or through other methods of authentication
* **Authorizes** those identities (or not) to access resources based on the policies associated with the identity

### Recap
* IAM is free but there are limits. It's a global service and is globally resilient (can cope with failure of large sections of AWS infra).
* Allows or denies its identities on its AWS account
* Does not allow direct control on external accounts or users.
* Identity federation (lets you take identities you already have e.g. business active directory) and MFA

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