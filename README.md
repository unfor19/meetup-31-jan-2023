# meetup-31-jan-2023

Playing with GitHub Actions

## Best Practices to speed up the Development process

The [sample app project](./quasar-project/) was generated with [yarn create quasar](https://quasar.dev/start/quasar-cli#tl-dr)

Initial fork of this repo - https://github.com/unfor19-org/meetup-31-jan-2023-initial


### Topeaks

1. How To Run A GitHub Runner Locally using a [self-hosted runner](https://docs.github.com/en/actions/hosting-your-own-runners/about-self-hosted-runners)
2. Aligning the development process with CI/CD using a [Makefile](https://opensource.com/article/18/8/what-how-makefile)
3. Testing [workflow_dispatch](https://docs.github.com/en/actions/using-workflows/events-that-trigger-workflows#workflow_dispatch) before merging to the [default branch](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-branches-in-your-repository/changing-the-default-branch)


### Requirements

- [Node 16.x+](https://nodejs.org/en/download/current/)
- [make](https://www.gnu.org/software/make/)
- Install quasar CLI
    ```bash
    yarn global add @quasar/cli
    ```
- (Optional) [GitHub CLI](https://github.com/cli/cli#installation)
- (Recommended) [Visual Studio Code IDE](https://code.visualstudio.com/)

### How To Run A GitHub Runner Locally - Self-Hosted Runner

1. Open a browser and navigate to your GitHub repository
2. Settings > Actions > Runners > Click **New self-hosted runner** ([Organization runners](https://docs.github.com/en/actions/hosting-your-own-runners/adding-self-hosted-runners))
   1. Select runner image (OS) and architecture (ARM64 for macOS M1)
   2. Make sure to check the for latest version of the runner agent here - [https://github.com/actions/runner/releases/latest](https://github.com/actions/runner/releases/latest)
   3. After creating the `actions-runner` directory, I prefer copy-pasting the commands from that page
      -  Each repository generates its own special token for registration, that is why I don't mind sharing mine publicly, anyone can register their machine to my public meetup-31-jan-2023 repo, I'm ok with that
   4. Configure the runner with the `./config.sh` script that was downloaded in previous steps
      1. Make sure provide a meaningful name
   5. [Run the runner as a service](https://docs.github.com/en/actions/hosting-your-own-runners/configuring-the-self-hosted-runner-application-as-a-service), this way it will always run in the background, even after you restart
      1. Execute the `./svc.sh` script to install
         ```bash
         ./svc.sh install
         ```
      2. Start the service manually for the first time ever
            ```bash
            ./svc.sh start
            ```
         Good output
            ```
            starting actions.runner.unfor19-meetup-31-jan-2023.meir-macbook-m1
            status actions.runner.unfor19-meetup-31-jan-2023.meir-macbook-m1:

            /$HOME/Library/LaunchAgents/actions.runner.unfor19-meetup-31-jan-2023.meir-macbook-m1.plist

            Started:
            48948 0 actions.runner.unfor19-meetup-31-jan-2023.meir-macbook-m1         
            ```
3. Check the runner is up and running - Idle means "waiting to run jobs"
4. Trigger the workflow dispatch from the GUI or with [GitHub CLI](https://cli.github.com/)
   - Authenticate GitHub CLI for the first time ever
      ```bash
      gh auth login
      ```
   - Trigger a `workflow_dispatch`
      ```bash
      gh workflow run Meetup-31-Jan-2023
      ```
   - View the run
      ```bash
      gh run list --workflow=pipeline.yml
      ```

#### Notes

 - [act](https://github.com/nektos/act) is an alternative approach; I prefer using the self-hosted runner approach as it simulates the real situation with variables
 - In most cases, you won't run the workflow directly on your host machine (macOS/Windows), and it'll probably be a Docker container of GitHub Actions Runner Controller, so either use this command to run a container locally
   ```bash
   DOCKER_IMAGE=summerwind/actions-runner:v2.301.1-ubuntu-20.04-6da1cde
   ```
   ```bash
   docker run --platform linux/amd64 --rm -it -v ${PWD}:/code/ --workdir /code/ --entrypoint bash "$DOCKER_IMAGE"
   ```
   Or customize the `DOCKER_IMAGE` according to the image you intend to run and then register that image using the above process


### Aligning The Development Process With CI/CD Using A Makefile

At this point the pipeline works and if you follow the instructions in [./quasar-project/README.md](./quasar-project/README.md) you'll be able to:
- Install dependencies with [yarn](https://yarnpkg.com/)
- [Lint](https://en.wikipedia.org/wiki/Lint_(material)) the code with [ESLint](https://eslint.org/) 
- Build the app with [Quasar](https://quasar.dev/quasar-cli-vite/developing-spa/deploying#general-deployment) (`./quasar-project/dist/spa`) so it can be deployed later on
- Run the app locally with [Quasar](https://quasar.dev/start/quasar-cli#installation-project-scaffolding) for local development

To make sure developers and CI/CD use the same commands, I prefer to abstract it with a [Makefile](./Makefile).

To view available commands, execute: `make help`

```
help                          Available make commands
install-global-dependencies   Install global dependencies
install-dependencies          Install app dependencies
lint                          Lint app
build                         Build app
run                           Run app locally
```


### Testing workflow_dispatch before merging to the default branch

Before performing the below, make sure to notify relevant entities in your organization.

[Set the new branch](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-branches-in-your-repository/changing-the-default-branch) `feature/new-workflow-dispatch` as the default branch, trigger the workflow dispatch, and then revert back by setting `master` as the default branch.

## Authors

Created and maintained by [Meir Gabay](https://github.com/unfor19)

## License

This project is licensed under the MIT License - see the [LICENSE](https://github.com/unfor19/meetup-31-jan-2023/blob/master/LICENSE) file for details
