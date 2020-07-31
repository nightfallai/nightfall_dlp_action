# nightfall_dlp
![nightfalldlp](https://www.finsmes.com/wp-content/uploads/2019/11/Nightfall-AI.png "nightfalldlp")
### NightfallDLP - a code review tool that protects you from committing sensitive information

NightfallDLP scans your commits for secrets or sensitive information and posts review comments to your code hosting 
services automatically. It’s intended to be used as a part of your CI to simplify the development process, improve your 
security, and ensure you never accidentally leak secrets or other sensitive information via an accidental commit.

## Supported CI Services
### GithubActions
Example using the NightfallDLP Github Action inside a Github Workflow  
_(*N.B. you must use the actions/checkout step before the running the nightfalldlp action in order for it to function properly)_
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
          EVENT_BEFORE: ${{ github.event.before }}
```

**Configuration**  
NightfallDLP requires a few pieces of configuration to run  
_Config File (detectors)_  
    - place a `.nightfalldlp/` directory within the root of your target repository, and inside it a `config.json` file
    in which you can configure your detectors (see `Detectors` section below for more information on Detectors)
ex.
```json
{
    "detectors": {
        "CREDIT_CARD_NUMBER": "POSSIBLE",
        "PHONE_NUMBER": "LIKELY"
    }
}
```

_Supported Github Events_  
NightfallDLP can run in a Github Workflow triggered by the following events:
1) PULL_REQUEST
2) PUSH

_Env Variables_  
These variables should be made available to the nightfall_dlp_action by adding them to the `env:` key in your workflow
1) NIGHTFALL_API_KEY
    - get a (FREE) Nightfall API Key by registering an account with the Nightfall API HERE
    - add this variable to your target repository's "Github Secrets" and passed in to your Github Workflow's `env`.
    
2) EVENT_BEFORE (*only for running Github Workflows on a `push` event)
    - the value for this var lives on the `github` context object in a Workflow - EVENT_BEFORE should always point to
    `${{ github.event.before }}` (as seen in the example above)
    

## Detectors
Each detector represents a type of information you want to search for in your code scans (e.g. CRYPTOGRAPHIC_KEY). The 
configuration is a map of canonical detector names to their likelihoods (link to more info on our API Documentation). The 
`likelihood` you specify per detector serves as a floor in which any findings with likelihoods of equal or greater values will be flagged.

### Versioning
The NightfallDLP Github Action issues Releases using semantic versioning
