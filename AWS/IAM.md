IAM users vs. roles vs. policies

An IAM user is an identity with long-term credentials that is used to interact with AWS in an account.

An IAM role is an identity you can create that has specific permissions with credentials that are valid for short durations. Roles can be assumed by entities that you trust.

A policy is an object in AWS that defines permissions.

A user can be created with a new policy (sts.AssumeRole) which allows it to assume role(s)