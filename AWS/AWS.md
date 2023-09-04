## Accounts

**An account is a container for identities (users) and resources**
Each has a name, unique email, and credit card.

Many business use more than one AWS account

Each account has a root user that is created when the account is created. 
- Root users are associated with the unique email address. 
- Root users can only access their respective account, not other accounts. 
- Root users has full control over the account and its resources, it cannot be restricted. 
- We need to be careful with the credentials of this account.

Resources bill to the AWS account payment method as they are consumed. The usage of resources is pay-as-you-go, i.e. use a service for 2 minutes, you pay for those 2 minutes. Some resources have free tier, a certain allocation of free usage per month.

We can use Identity and Access Management service (IAM) to create users, groups, and roles which can be restricted. All of these identities start with no access to the account, and must be explicitly granted access. Cross-account permissions is possible.

Conceptually, accounts have a boundary. All "damage" done to an account is confined to that account. Therefore, it is good to have multiple accounts for separate stages (e.g. dev, test, prod), teams, clients, and products. The boundary also keeps things out by default, all external identities must be explicitly configured for access to an account.

### Creating accounts: general + production

Starting with a general/management account. We'll implement:
* Multi-factor authentication
* Budget
* An IAM user called IAMADMIN
Then do the same for a second account called production

Gmail makes creating multiple AWS accounts easier. The plus sign can create dynamic aliases. Unique email addresses always points the single Gmail account.
e.g. catguy@gmail.com -> catguy+AWSAccount1@gmail.com, etc.

In Account under IAM User and Role Access to Billing Information, we check the Activate IAM Access box and update.

Also we select us-east-1 as the region.

#### Multi-factor authentication (MFA)

Factors are different pieces of evidence that prove identity.
Multiple factor authentication uses multiple different types of factors for authentication and logging in to applications.

Types of factors:
* Knowledge: something you know, e.g. usernames and passwords
* Possession: something you have, e.g. bank card, MFA device/app
* Inherent: something you are, e.g. fingerprint, face, voice, iris
* Location: a location (physical) or network (corp/home wifi)

More factors = more security and harder to fake

By default in AWS, we have username and password. Single factor.
If these are leaked then someone can infiltrate.

MFA via virtual MFA app like Authy. QR code generatable under main dropdown -> Security credentials

#### Budget

Varying by resource, there are different kind of free trials:
* short-term free trials upon first using a service (by hour or number of requests)
* free for 12-month period following account creation
* Always free

The Billing dashboard is home for all billing info associated with the account. Can view bills, payments, credits, cost & usage reports, cost explorer, etc.. Can estimate bill for the month.

Billing preferences: 
* Receive PDF invoice by Email
* **Receive free tier usage alerts!**
* **Receive billing alerts!**

AWS Budget service
Create a budget (custom template)
Monthly $10 USD with alerts for 50% and 100% spending

## IAM Basics

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
