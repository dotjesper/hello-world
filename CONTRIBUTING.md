# Contributing *(Preview)*

By submitting code as an individual you agree to the [individual contributor license agreement](https://gitlab.com/gitlab-org/gitlab-ce/blob/master/doc/legal/individual_contributor_license_agreement.md). By submitting code as an entity you agree to the [corporate contributor license agreement](https://gitlab.com/gitlab-org/gitlab-ce/blob/master/doc/legal/corporate_contributor_license_agreement.md).

## Coding conventions
We optimize for readability:
 - We indent using two spaces (soft tabs)
 - We use HAML for all views
 - We avoid logic in views, putting HTML generators into helpers
 - We ALWAYS put spaces after list items and method parameters ([1, 2, 3], not [1,2,3]), around operators (x += 1, not x+=1), and around hash arrows.
 - Always use cwd-relative paths rather than root-relative paths in image URLs in any CSS. So instead of url('/images/blah.gif'), use url('../images/blah.gif').

*Thanks*
