# nightfall_dlp
![nightfalldlp](https://cdn.nightfall.ai/nightfall-dark-logo-tm.png "nightfalldlp")
### NightfallDLP - a code review tool that protects you from committing sensitive information

NightfallDLP scans your commits for secrets or sensitive information and posts review comments to your code hosting 
services automatically. It’s intended to be used as a part of your CI to simplify the development process, improve your 
security, and ensure you never accidentally leak secrets or other sensitive information via an accidental commit.

## Supported CI Services
### GithubActions
Example using the NightfallDLP Github Action inside a Github Workflow  
_(**N.B.** you must use the actions/checkout step before the running the nightfalldlp action in order for it to function properly)_
```yaml
name: nightfalldlp
on:
  push:
    branches:
      - master
  pull_request:
jobs:
  run-nightfalldlp:
    name: nightfalldlp
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Repo Action
        uses: actions/checkout@v2

      - name: nightfallDLP action step
        uses: nightfallai/nightfall_dlp_action@CreateAction
        env:
          NIGHTFALL_API_KEY: ${{ secrets.NIGHTFALL_API_KEY }}
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          EVENT_BEFORE: ${{ github.event.before }}
```

### Action Spec  
NightfallDLP requires a config file and a few Environment variables in order to run  

**Config File (detectors)**  
 - place a `.nightfalldlp/` directory within the root of your target repository, and inside it a `config.json` file
 in which you can configure your detectors (see `Detectors` section below for more information on Detectors)  
 - inside the `detectors` map the keys are Detector Names and the *values are the minimum likelihood threshold for a detector 
  to be triggered _(N.B. minimum thresholds are not currently supported, so if one is specified for a detector - regardless of what it is - we will use `POSSIBLE`)_

**Additional Configuration**

You can add additional fields to your config to ignore tokens and files as well as specify which files to exclusively scan on.

**Token Exclusion**

To ignore specific tokens, you can add the `tokenExclusionList` field to your config. The `tokenExclusionList` is a list of strings, and it mutes findings that match any of the given regex patterns.

Here's an example use case:

```tokenExclusionList: ["NF-gGpblN9cXW2ENcDBapUNaw3bPZMgcABs", "^127\\."]```

In the example above, findings with the API token `NF-gGpblN9cXW2ENcDBapUNaw3bPZMgcABs` as well as local IP addresses starting with `127.` would not be reported. For more information on how we match tokens, take a look at [regexp](https://golang.org/pkg/regexp/).

**File Inclusion/Exclusion**

To omit files from being scanned, you can add the `fileExclusionList` field to your config. In addition, to only scan on certain files, add the `fileInclusionList` to the config.

Here's an example use case:
```
    fileExclusionList: ["*/tests/*"],
    fileInclusionList: ["*.go", "*.json"]
```
In the example, we are ignoring all file paths with a `tests` subdirectory, and only scanning on `go` and `json` files.
Note: we are using [gobwas/glob](https://github.com/gobwas/glob) to match file path patterns. Unlike the token regex matching, file paths must be completely matched by the given pattern. e.g. If `tests` is a subdirectory, it will not be matched by `tests/*`, which is only a partial match.

 - sample `.nightfalldlp/config.json` file
```json
{
  "detectors": [
    "CREDIT_CARD_NUMBER",
    "PHONE_NUMBER",
    "API_KEY",
    "CRYPTOGRAPHIC_KEY",
    "RANDOMLY_GENERATED_TOKEN",
    "US_SOCIAL_SECURITY_NUMBER",
    "AMERICAN_BANKERS_CUSIP_ID",
    "US_BANK_ROUTING_MICR",
    "ICD9_CODE",
    "ICD10_CODE",
    "US_DRIVERS_LICENSE_NUMBER",
    "US_PASSPORT",
    "EMAIL_ADDRESS",
    "IP_ADDRESS"
  ],
  "tokenExclusionList": ["NF-gGpblN9cXW2ENcDBapUNaw3bPZMgcABs", "^127\\."],
  "fileInclusionList": ["*.go", "*.json"],
  "fileExclusionList": ["*/tests/*"]
}
```

**Env Variables**      
These variables should be made available to the nightfall_dlp_action by adding them to the `env:` key in your workflow  
1) `NIGHTFALL_API_KEY`
    - get a (FREE) Nightfall AI DLP Scan API Key by registering an account with the [Nightfall API](https://nightfall.ai/api)
    - add this variable to your target repository's "Github Secrets" and passed in to your Github Workflow's `env`.

2) `GITHUB_TOKEN`
    - this is automatically injected by Github inside each Workflow (via the `secrets` context), you just need to set it 
    to the env key. This variable should always point to `secrets.GITHUB_TOKEN`
    - this token is used to authenticate to Github to write Comments/Annotations to your Pull Requests and Pushes

3) `EVENT_BEFORE` (*only required for Github Workflows running on a `push` event)
    - the value for this var lives on the `github` context object in a Workflow - EVENT_BEFORE should always point to
    `${{ github.event.before }}` (as seen in the example above)
    
**Supported Github Events**  
NightfallDLP can run in a Github Workflow triggered by the following events:
1) PULL_REQUEST
2) PUSH

NightfallDLP is currently unable to be used in forked Github repositories due to Github's disabling of secrets sharing when Workflows originate from forks.

## Detectors
Each detector represents a type of information you want to search for in your code scans (e.g. CRYPTOGRAPHIC_KEY). The 
configuration is a map of canonical detector names to their likelihoods (link to more info on our API Documentation). The 
`likelihood` you specify per detector serves as a floor in which any findings with likelihoods of equal or greater values will be flagged.

## Nightfall AI DLP Scan API
Nightfall AI’s DLP Scan API allows you to discover, classify, and protect sensitive data across all of your SaaS applications. 
Nightfall’s mission is to enable you to protect your internal secrets as well as your customers’ sensitive information.  
[Request access](https://nightfall.ai/api/)

## Versioning
The NightfallDLP Github Action issues Releases using semantic versioning
