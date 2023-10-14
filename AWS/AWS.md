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