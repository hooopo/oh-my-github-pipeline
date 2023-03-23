## Oh My GitHub Pipeline

## GitHub Data Sync

This repository provides a powerful data pipeline that can sync all historical data for a GitHub user, as well as data for other users, to a free MySQL-compatible cloud database, TiDB Cloud. It can be used as a standalone data pipeline and combined with [Oh My GitHub Dashboard](https://github.com/hooopo/oh-my-github-dashboard) to create a personal dashboard.

In addition to generating a dashboard, this GitHub user data can also be used for the following purposes:

* Generating a resume
* Providing seed data for your frontend app demo
* Feeding LLM to generate a digital persona
* Syncing to your social networking site
* Generating a personal branding website
* Generating a weekly report

### Standalone Data Pipeline

To use this repository as a standalone data pipeline, simply set the environment variables and the GitHub action will run automatically every hour. This will sync the specified user's GitHub data to TiDB Cloud.

![image](https://user-images.githubusercontent.com/63877/226034715-edf3ea0f-870f-4933-8f6c-ea28a56dad1b.png)

Environment Secrets

To use this repository, you will need to set the following secrets on GitHub:

| Secret Name | Description |
| --- | --- |
| ACCESS_TOKEN | A personal access token provided by GitHub, which can be obtained from [Sign in to GitHub · GitHub](https://github.com/settings/tokens). |
| DATABASE_URL | The MySQL connection information in URI format for TiDB Cloud. You will need to register and create a serverless cluster on [https://tidb.cloud](https://tidb.cloud/), and the URI format should contain the necessary information for connecting to the cluster. An example of the DATABASE_URL format is: mysql2://xxx.root:password@hostxx.tidbcloud.com:4000/db_name |
| USER_LOGIN | Optional, default is your access_token related user. The user login of the account you want to sync. This can be your own GitHub account's user login or the user login of other users you want to sync. Note that if you choose to sync other users, you won't be able to sync private repositories and author_association information. |
| OPENAI_TOKEN | Optional, use it to generate story for your OSS contribution|

⚠️ Make sure you enable GitHub Action for this forked repo.

![image](https://user-images.githubusercontent.com/63877/226040673-bf5467ee-d8c7-4380-a705-0504229ddf16.png)


### Personal Dashboard

See the [Oh My GitHub Dashboard](https://github.com/hooopo/oh-my-github-dashboard) repository for more information on how to create a personal dashboard.

![image](https://user-images.githubusercontent.com/63877/226038417-89937699-8cbb-49f1-8b0f-992db6bc2f26.png)


## How it works

![image](https://github.com/hooopo/oh-my-github-dashboard/raw/main/static/how_it_works.png)