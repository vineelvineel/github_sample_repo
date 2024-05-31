# GitHub Issue Post Comment

This is a Rails application that acts as a GitHub App to automatically detect when a new GitHub issue is created and writes a comment to remind the issue creator to provide a time estimate if it’s missing. This helps the team scope and schedule projects more effectively.

## Features

- **GitHub App Integration:** Uses a GitHub app to integrate with GitHub's APIs and subscribe to events.
- **Issue Creation Event:** Listens for the `issues` event and handles the `opened` action, which is triggered when a new issue is created.
- **Estimate Detection:** Analyzes the body of the newly created issue and checks if it contains an estimate in the format "Estimate: X days" (e.g., "Estimate: 2 days").
- **Reminder Comment:** Posts a comment on the issue, reminding the issue creator to provide an estimate if it's missing.

## Setup

### Prerequisites

- Ruby v3.3.1
- Rails v7.1.3.3

### Installation

1. **Clone the repository:**

  ```bash
    git clone git@github.com:vineelvineel/github_sample_repo.git
    cd github_sample_repo
    git checkout post_comments
  ```

2. **Install dependencies:**

   ```bash
   bundle install
   ```

3. **Create GitHub App:**

   - Go to your GitHub account settings.
   - Navigate to "Developer settings" -> "GitHub Apps".
   - Click "New GitHub App".
   - Fill in the required details:
     - **GitHub App name:** `vineelvineel-webhook-github-events`
     - **Homepage URL:** `https://github.com/vineelvineel/github_sample_repo`
     - **Webhook URL:** `https://smee.io/CRqjFX3UBQnT1sX`
       - Created a webhook url that makes call to localhost:3000
       - Use node v20
       - npm install --global smee-client
       - Then Start the webhook with smee -u https://smee.io/CRqjFX3UBQnT1sX
     - **Webhook secret:** `your_secret` # will send in email
   - Click "Create GitHub App".

4. **Set up Rails credentials:**

   ```bash
   EDITOR=vi rails credentials:edit
   ```

   Add the following entries to the credentials file:

   ```yaml
   github:
     app_identifier: your_github_app_id
     token: github_token
     webhook_secret: your_github_webhook_secret
   ```

   Replace the placeholders with the actual GitHub App ID, webhook secret, and token

7. **Start the server:**

   ```
   rails server
   ```

## Usage

1. **Create a new issue:**
   - Go to a repository where the GitHub App is installed. (https://github.com/vineelvineel/github_sample_repo)
   - Create a new issue without an estimate in the body. (https://github.com/vineelvineel/github_sample_repo/issues)
   - The app should automatically comment on the issue, reminding the creator to add an estimate.
