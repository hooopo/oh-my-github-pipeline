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

### Setup Data Pipeline

To use this repository as a standalone data pipeline, simply fork this repo, and set the environment variables and the GitHub action will run automatically every hour. This will sync the specified user's GitHub data to TiDB Cloud.

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

### Table Schema

This project involves the following table structures and their relationships, as illustrated in the diagram below.

Table relationships

The curr_user table contains only one record and is used by BI tools to directly locate the synchronized target user through SQL queries. If you are using other programming languages, you can directly query the users table using the login parameter: where login = 'user_login'.

Please refer to the table below for a brief description of each table's structure.

```sql
+------------------+--------------+------+-----+---------+----------------+
| Field            | Type         | Null | Key | Default | Extra          |
+------------------+--------------+------+-----+---------+----------------+
| id               | bigint(20)   | NO   | PRI | <null>  | auto_increment |
| login            | varchar(255) | NO   |     | <null>  |                |
| company          | varchar(255) | YES  |     | <null>  |                |
| location         | varchar(255) | YES  |     | <null>  |                |
| twitter_username | varchar(255) | YES  |     | <null>  |                |
| followers_count  | int(11)      | YES  |     | 0       |                |
| following_count  | int(11)      | YES  |     | 0       |                |
| region           | varchar(255) | YES  |     | <null>  |                |
| created_at       | varchar(255) | NO   |     | <null>  |                |
| updated_at       | varchar(255) | NO   |     | <null>  |                |
+------------------+--------------+------+-----+---------+----------------+

```

```sql
+--------------------+--------------+------+-----+---------+----------------+
| Field              | Type         | Null | Key | Default | Extra          |
+--------------------+--------------+------+-----+---------+----------------+
| id                 | bigint(20)   | NO   | PRI | <null>  | auto_increment |
| name               | varchar(255) | YES  |     | <null>  |                |
| owner              | varchar(255) | YES  |     | <null>  |                |
| user_id            | bigint(20)   | YES  |     | <null>  |                |
| license            | varchar(255) | YES  |     | <null>  |                |
| is_private         | tinyint(1)   | YES  |     | <null>  |                |
| disk_usage         | int(11)      | YES  |     | <null>  |                |
| language           | varchar(255) | YES  |     | <null>  |                |
| description        | text         | YES  |     | <null>  |                |
| is_fork            | tinyint(1)   | YES  |     | <null>  |                |
| parent_id          | bigint(20)   | YES  |     | <null>  |                |
| fork_count         | int(11)      | YES  |     | <null>  |                |
| stargazer_count    | int(11)      | YES  |     | <null>  |                |
| pushed_at          | datetime(6)  | YES  |     | <null>  |                |
| topics             | json         | YES  |     | <null>  |                |
| created_at         | datetime(6)  | NO   |     | <null>  |                |
| updated_at         | datetime(6)  | NO   |     | <null>  |                |
| is_in_organization | tinyint(1)   | YES  |     | 0       |                |
+--------------------+--------------+------+-----+---------+----------------+
```

```sql
+--------------------+--------------+------+-----+---------+----------------+
| Field              | Type         | Null | Key | Default | Extra          |
+--------------------+--------------+------+-----+---------+----------------+
| id                 | bigint(20)   | NO   | PRI | <null>  | auto_increment |
| repo_id            | bigint(20)   | YES  |     | <null>  |                |
| locked             | tinyint(1)   | YES  |     | <null>  |                |
| title              | varchar(255) | YES  |     | <null>  |                |
| closed             | tinyint(1)   | YES  |     | <null>  |                |
| closed_at          | datetime(6)  | YES  |     | <null>  |                |
| state              | varchar(255) | YES  |     | <null>  |                |
| number             | int(11)      | YES  |     | <null>  |                |
| user_id            | bigint(20)   | YES  | MUL | <null>  |                |
| author             | varchar(255) | YES  | MUL | <null>  |                |
| author_association | varchar(255) | YES  |     | <null>  |                |
| created_at         | datetime(6)  | NO   | MUL | <null>  |                |
| updated_at         | datetime(6)  | NO   | MUL | <null>  |                |
+--------------------+--------------+------+-----+---------+----------------+
```

```sql
+--------------------+--------------+------+-----+---------+----------------+
| Field              | Type         | Null | Key | Default | Extra          |
+--------------------+--------------+------+-----+---------+----------------+
| id                 | bigint(20)   | NO   | PRI | <null>  | auto_increment |
| repo_id            | bigint(20)   | YES  |     | <null>  |                |
| locked             | tinyint(1)   | YES  |     | <null>  |                |
| title              | varchar(255) | YES  |     | <null>  |                |
| closed             | tinyint(1)   | YES  |     | <null>  |                |
| closed_at          | datetime(6)  | YES  |     | <null>  |                |
| state              | varchar(255) | YES  |     | <null>  |                |
| number             | int(11)      | YES  |     | <null>  |                |
| author             | varchar(255) | YES  | MUL | <null>  |                |
| user_id            | bigint(20)   | YES  | MUL | <null>  |                |
| author_association | varchar(255) | YES  |     | <null>  |                |
| is_draft           | tinyint(1)   | YES  |     | <null>  |                |
| additions          | int(11)      | YES  |     | 0       |                |
| deletions          | int(11)      | YES  |     | 0       |                |
| merged_at          | datetime(6)  | YES  |     | <null>  |                |
| merged_by          | varchar(255) | YES  |     | <null>  |                |
| changed_files      | int(11)      | YES  |     | 0       |                |
| merged             | tinyint(1)   | YES  |     | <null>  |                |
| comments_count     | int(11)      | YES  |     | 0       |                |
| created_at         | datetime(6)  | NO   | MUL | <null>  |                |
| updated_at         | datetime(6)  | NO   | MUL | <null>  |                |
+--------------------+--------------+------+-----+---------+----------------+
```

```sql
+--------------------+--------------+------+-----+---------+----------------+
| Field              | Type         | Null | Key | Default | Extra          |
+--------------------+--------------+------+-----+---------+----------------+
| id                 | bigint(20)   | NO   | PRI | <null>  | auto_increment |
| repo_id            | bigint(20)   | YES  |     | <null>  |                |
| user_id            | bigint(20)   | YES  |     | <null>  |                |
| author_association | varchar(255) | YES  |     | <null>  |                |
| issue_id           | bigint(20)   | YES  |     | <null>  |                |
| created_at         | datetime(6)  | NO   |     | <null>  |                |
| updated_at         | datetime(6)  | NO   |     | <null>  |                |
+--------------------+--------------+------+-----+---------+----------------+
```

```sql

+--------------------+--------------+------+-----+---------+----------------+
| Field              | Type         | Null | Key | Default | Extra          |
+--------------------+--------------+------+-----+---------+----------------+
| id                 | bigint(20)   | NO   | PRI | <null>  | auto_increment |
| repo_id            | bigint(20)   | YES  |     | <null>  |                |
| user_id            | bigint(20)   | YES  |     | <null>  |                |
| author_association | varchar(255) | YES  |     | <null>  |                |
| created_at         | datetime(6)  | NO   |     | <null>  |                |
| updated_at         | datetime(6)  | NO   |     | <null>  |                |
+--------------------+--------------+------+-----+---------+----------------+
```

```sql
+----------------+------------+------+-----+---------+-------+
| Field          | Type       | Null | Key | Default | Extra |
+----------------+------------+------+-----+---------+-------+
| user_id        | bigint(20) | NO   | MUL | <null>  |       |
| target_user_id | bigint(20) | NO   |     | <null>  |       |
+----------------+------------+------+-----+---------+-------+
```

```sql
+----------------+------------+------+-----+---------+-------+
| Field          | Type       | Null | Key | Default | Extra |
+----------------+------------+------+-----+---------+-------+
| user_id        | bigint(20) | NO   | MUL | <null>  |       |
| target_user_id | bigint(20) | NO   |     | <null>  |       |
+----------------+------------+------+-----+---------+-------+
```

```sql
+------------+-------------+------+-----+---------+-------+
| Field      | Type        | Null | Key | Default | Extra |
+------------+-------------+------+-----+---------+-------+
| user_id    | bigint(20)  | NO   | MUL | <null>  |       |
| repo_id    | bigint(20)  | NO   |     | <null>  |       |
| starred_at | datetime(6) | NO   |     | <null>  |       |
+------------+-------------+------+-----+---------+-------+
```

```sql
+----------------------------+--------------+------+-----+---------+----------------+
| Field                      | Type         | Null | Key | Default | Extra          |
+----------------------------+--------------+------+-----+---------+----------------+
| id                         | bigint(20)   | NO   | PRI | <null>  | auto_increment |
| login                      | varchar(255) | NO   |     | <null>  |                |
| company                    | varchar(255) | YES  |     | <null>  |                |
| location                   | varchar(255) | YES  |     | <null>  |                |
| twitter_username           | varchar(255) | YES  |     | <null>  |                |
| followers_count            | int(11)      | YES  |     | 0       |                |
| following_count            | int(11)      | YES  |     | 0       |                |
| region                     | varchar(255) | YES  |     | <null>  |                |
| created_at                 | varchar(255) | NO   |     | <null>  |                |
| updated_at                 | varchar(255) | NO   |     | <null>  |                |
| last_issue_cursor          | varchar(255) | YES  |     | <null>  |                |
| last_pr_cursor             | varchar(255) | YES  |     | <null>  |                |
| last_follower_cursor       | varchar(255) | YES  |     | <null>  |                |
| last_following_cursor      | varchar(255) | YES  |     | <null>  |                |
| last_starred_repo_cursor   | varchar(255) | YES  |     | <null>  |                |
| last_repo_cursor           | varchar(255) | YES  |     | <null>  |                |
| last_commit_comment_cursor | varchar(255) | YES  |     | <null>  |                |
| last_issue_comment_cursor  | varchar(255) | YES  |     | <null>  |                |
| bio                        | text         | YES  |     | <null>  |                |
| story                      | text         | YES  |     | <null>  |                |
+----------------------------+--------------+------+-----+---------+----------------+
```


### Personal Dashboard

See the [Oh My GitHub Dashboard](https://github.com/hooopo/oh-my-github-dashboard) repository for more information on how to create a personal dashboard.

![image](https://user-images.githubusercontent.com/63877/226038417-89937699-8cbb-49f1-8b0f-992db6bc2f26.png)


## How it works

![image](https://github.com/hooopo/oh-my-github-dashboard/raw/main/static/how_it_works.png)