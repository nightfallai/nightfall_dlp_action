# Nightfall DLP GitHub Action
![nightfalldlp](https://nightfall.ai/wp-content/uploads/2021/05/nightfall-dark-logo-tm_40.png)
## [Nightfall](https://nightfall.ai) DLP Action: A code review tool that protects you from committing sensitive information to your repositories.

The Nightfall DLP Action scans your code commits upon Pull Request for sensitive information - like credentials & secrets, PII, credit card numbers & more - and posts review comments to your code hosting service automatically. The Nightfall DLP Action is intended to be used as a part of your CI to simplify the development process, improve your security, and ensure you never accidentally leak secrets or other sensitive information via an accidental commit.

## Example
Here's an example of the Nightfall DLP GitHub Action providing feedback on a Pull Request: 

![nightfall-dlp-action-example](https://nightfall.ai/wp-content/uploads/2020/08/nightfall-dlp-action-screenshot.png)

The action runs when configured as a job in your GitHub Workflow:

_**Note:** you must use the actions/checkout step as shown below before the running the nightfalldlp action in order for it to function properly_

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
        uses: nightfallai/nightfall_dlp_action@v1.0.0
        env:
          NIGHTFALL_API_KEY: ${{ secrets.NIGHTFALL_API_KEY }}
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          EVENT_BEFORE: ${{ github.event.before }}
```

## Usage
**1. Get a Nightfall API key.**

The Nightfall DLP Action is powered by the Nightfall Developer Platform. Learn more and request access to a free API key **[here](https://nightfall.ai/api/)**. Alternatively, you can email **[sales@nightfall.ai](mailto:sales@nightfall.ai)** to provision a free account.

**2. Set up config file to specify your condition set.**

- Place a `.nightfalldlp/` directory within the root of your target repository, and inside it a `config.json` file in which you can configure your condition sets (see `Nightfalldlp Config File` section below for more information on condition sets)
- See `Additional Configuration` section for more advanced configuration options

- If a config is not included, a default config consisting of a condition set with the `API_KEY` and `CRYPTOGRAPHIC_KEY` detectors will be used.

**3. Set up a few environment variables.**     
These variables should be made available to the nightfall_dlp_action by adding them to the `env:` key in your workflow:

- `NIGHTFALL_API_KEY`
    - Get a free Nightfall DLP API Key by registering for an account with the [Nightfall Developer Platform](https://nightfall.ai/api)
    - Add this variable to your target repository's "GitHub Secrets" and passed in to your GitHub Workflow's `env`.

- `GITHUB_TOKEN`
    - This is automatically injected by GitHub inside each Workflow (via the `secrets` context), you just need to set it to the `env` key. This variable should always point to `secrets.GITHUB_TOKEN`
    - This token is used to authenticate to GitHub to write Comments/Annotations to your Pull Requests and Pushes

- `EVENT_BEFORE` (*only required for GitHub Workflows running on a `push` event)
    - the value for this var lives on the `github` context object in a Workflow - EVENT_BEFORE should always point to `${{ github.event.before }}` (as seen in the example above)
    
- `BASE_URL` (*for Enterprise only)
    - if you are using Github Enterprise, you must set this variable to your enterprise domain name to connect to the Github API.
    
## Supported GitHub Events
The Nightfall DLP Action can run in a GitHub Workflow triggered by the following events:

- `PULL_REQUEST`
- `PUSH`

The Nightfall DLP Action is currently unable to be used in forked GitHub repositories due to GitHub's disabling of secrets sharing when Workflows originate from forks.

## NightfallDLP Config File

The `.nightfalldlp/config.json` file is used as a centralized config file to control what conditions/detectors to scan with and what content you want to scan for pull requests. It includes the following adjustable fields to fit your needs based on the Nightfall Developer Platform. For additional detail, review the Developer Platform documentation [here](https://toolkit.nightfalldlp.com/docs).

### ConditionSetUUID

A Condition Set UUID is a unique identifier of a Condition Set, which can be created via the [Nightfall Console](app.nightfall.ai).
Once defined, you can simply input the UUID in your config file, e.g.

```json
{ "conditionSetUUID": "A0BA0D76-78B4-4E10-B653-32996060316B" }
```

Note: by default, if both `conditionSetUUID` and `conditions` are specified, only the `conditionSetUUID` will be used.

### Conditions

Conditions are a list of conditions specified inline. Each `condition` contains a nested `detector` object as well as two additional parameters: `minNumFindings` and `minConfidence`.

```json
{
  "conditions": [
    {
      "minNumFindings": 1,
      "minConfidence": "POSSIBLE",
      "detector": {}
    }
  ]
}
```

`minNumFindings` specifies the minimum number of findings required to return for one request, e.g. if you set `minNumFindings` to be 2, and Nightfall identifies only 1 finding within the request payload related to that detector, that finding then will be filtered out from the response.

`minConfidence` specifies the minimum threshold to trigger a potential finding to be captured. We have five levels of confidence from least sensitive to most sensitive:

- `VERY_LIKELY`
- `LIKELY`
- `POSSIBLE`
- `UNLIKELY`
- `VERY_UNLIKELY`

### Detector

A detector is either a pre-built Nightfall detector or custom regex or wordlist detector that you can create. This is specified by the `detectorType` field.

#### Nightfall Pre-Built Detector

  ```json
  {
    "detector": {
      "detectorType": "NIGHTFALL_DETECTOR",
      "nightfallDetector": "API_KEY",
      "displayName": "apiKeyDetector"
    }
  }
  ```

- Within `detector` struct

  - First specify `detectorType` as `NIGHTFALL_DETECTOR`
  - Pick the Nightfall detector you would like to use from our [Detector Glossary](https://toolkit.nightfalldlp.com/login?back_to=%2Fdocs&dest=https%3A%2F%2Fdeveloper.nightfall.ai%2Freference%23glossary). The Glossary includes a broad set of PII, PHI, PCI, credentials & secrets, and more to choose from. We recommend the following two as a simple starting point:
    - `API_KEY`
    - `CRYPTOGRAPHIC_KEY`

  - Set a display name for your detector, as this will be attached on your findings

#### Custom Regex

We also support custom regex as a `detector`, which are defined as followed:

```json
{
  "detector": {
    "detectorType": "REGEX",
    "regex": {
      "pattern": "coupon:\\d{4,}",
      "isCaseSensitive": false
    },
    "displayName": "simpleRegexCouponDetector"
  }
}
```

#### Custom Word List

Word list detectors look for words you specify in a list. Example below:

```json
{
  "detector": {
    "detectorType": "WORD_LIST",
    "wordList": {
      "values": ["key", "credential"],
      "isCaseSensitive": false
    },
    "displayName": "simpleWordListKeyDetector"
  }
}
```

#### Additional Detector Configuration Options

Aside from specifying which detector to use for a condition, you can also specify some additional rules to attach. They are `contextRules` and `exclusionRules`.

##### Context Rules
A context rule evaluates the surrounding context (i.e. preceding and following characters) of a finding and adjusts the finding's confidence if the input context rule pattern exists.

Example:

```json
{
  "detector": {
    // ...... other detector fields
    "contextRules": [
      {
        "regex": {
          "pattern": "my cc",
          "isCaseSensitive": true
        },
        "proximity": {
          "windowBefore": 30,
          "windowAfter": 30
        },
        "confidenceAdjustment": {
          "fixedConfidence": "VERY_LIKELY"
        }
      }
    ]
  }
}
```

- `regex` field specifies a regex to trigger
- `proximity` is defined as the number pre|post chars surrounding the finding on which to conduct the search
- `confidenceAdjustment` is the confidence level to adjust the finding to upon existence of the input context

As an example, say we have the following line of text in a file `my cc number: 4242-4242-4242-4242`, and `4242-4242-4242-4242` is detected as a credit card number with `confidence` of `POSSIBLE`. If we had the context rule above, the confidence level of this finding will be bumped up to `VERY_LIKELY` because the characters preceding the finding, `my cc`, match the regex.

##### Exclusion Rules
Exclusion rules on individual conditions are used to mute findings related to that condition's detector.

Example:

```json
{
  "detector": {
    // ...... other detector fields
    "exclusionRules": [
      {
        "matchType": "PARTIAL",
        "exclusionType": "REGEX",
        // specify one of these values based on the type specified above
        "regex": {
          "pattern": "4242-4242-\\d{4}-\\d{4}",
          "isCaseSensitive": true
        },
        "wordList": {
          "values": ["4242"],
          "isCaseSensitive": false
        }
      }
    ]
  }
}
```

- `exclusionType` specifies either a `REGEX` or `WORD_LIST`
- `regex` field specifies a regex to trigger, if you choose to use `REGEX` type
- `matchType` can be either `PARTIAL` or `FULL` - to be a full match, the entire finding must match the regex pattern or word exactly, whereas findings containing more than just the regex pattern or word are considered partial matches. Example: Suppose we have a finding of "4242-4242" with exclusion regex of `4242`. If you use `PARTIAL`, this finding will be excluded from results, while using `FULL` will not exclude this finding, since the regex only partially matches the finding.

## Additional Configuration

You can add additional fields to your config to ignore tokens and files from being flagged, as well as specify which files to exclusively scan.

### Token Exclusion

To ignore specific tokens from being flagged universally, you can add the `tokenExclusionList` field to your config. The `tokenExclusionList` is a list of strings, and it mutes findings that match any of the given regex patterns.

Here's an example use case:

```tokenExclusionList: ["NF-gGpblN9cXW2ENcDBapUNaw3bPZMgcABs", "^127\\."]```

In the example above, findings with the API token `NF-gGpblN9cXW2ENcDBapUNaw3bPZMgcABs` as well as local IP addresses starting with `127.` would not be reported. For more information on how we match tokens, take a look at [regexp](https://golang.org/pkg/regexp/).

### File Inclusion & Exclusion

To omit files from being scanned, you can add the `fileExclusionList` field to your config. In addition, to only scan specific files, add the `fileInclusionList` to the config.

Here's an example use case:
```
    fileExclusionList: ["*/tests/*"],
    fileInclusionList: ["*.go", "*.json"]
```
In the example, we are ignoring all file paths with a `tests` subdirectory, and only scanning on `go` and `json` files.
Note: we are using [gobwas/glob](https://github.com/gobwas/glob) to match file path patterns. Unlike the token regex matching, file paths must be completely matched by the given pattern. e.g. If `tests` is a subdirectory, it will not be matched by `tests/*`, which is only a partial match.

## [Nightfall Developer Platform](https://nightfall.ai/api)
With the Nightfall Developer Platform, you can inspect & classify your data, wherever it lives. Via REST API, programmatically get structured results from Nightfall's deep learning-based detectors for things like credit card numbers, API keys, and more. Scan data easily in your own third-party apps, internal apps, and data silos. Leverage these classifications in your own workflows - for example, saving them to a data warehouse or pushing them to a SIEM. Request access & learn more **[here](https://nightfall.ai/api/)**.

## Versioning
The Nightfall DLP Action issues releases using semantic versioning.

## Support
For help, please email us at **[support@nightfall.ai](mailto:support@nightfall.ai)**.
