# Courses App [DEMO]

Courses App is an **Udemy-like online learning platform** built with Ruby on Rails. It enables course creators (teachers) to publish and sell courses, while students can enroll, track progress, and leave reviews. The platform includes payment processing, multi-provider authentication, and role-based access control.

## Tech stack

- **Backend**: Ruby 3.0.7, Rails 6.1
- **Database**: PostgreSQL
- **Frontend**: Yarn, Webpack 4, Bootstrap 5.3, jQuery
- **Authentication**: Devise with OmniAuth (Google, GitHub, Facebook)
- **Authorization**: Pundit policies with Rolify roles
- **Payments**: Stripe (Checkout Sessions)
- **File Storage**: local disk (development)

## Installation

### 1. Clone the repository

```bash
git clone https://github.com/paranabuka/courses-app.git
cd courses-app
```

### 2. Install dependencies

```bash
bundle install
yarn install
```

### 3. Configure credentials

Delete the existing encrypted credentials and create your own:

```bash
rm config/credentials.yml.enc

# Example with VS Code or use other editor of your preference
EDITOR="code --wait" rails credentials:edit
```

Add the following structure (replace with your actual keys):

```yaml
recaptcha:
  site_key: YOUR_RECAPTCHA_SITE_KEY
  secret_key: YOUR_RECAPTCHA_SECRET_KEY

google_analytics_id: YOUR_GOOGLE_ANALYTICS_ID

google_oauth2:
  app_id: YOUR_GOOGLE_OAUTH2_APP_ID
  app_secret: YOUR_GOOGLE_OAUTH2_APP_SECRET

github_oauth:
  app_id: YOUR_GITHUB_OAUTH_APP_ID
  app_secret: YOUR_GITHUB_OAUTH_APP_SECRET

facebook_oauth:
  app_id: YOUR_FACEBOOK_OAUTH_APP_ID
  app_secret: YOUR_FACEBOOK_OAUTH_APP_SECRET

stripe:
  publishable_key: YOUR_STRIPE_PUBLISHABLE_KEY
  secret_key: YOUR_STRIPE_SECRET_KEY
```

### 4. Setup database

```bash
rails db:create db:migrate
```

## Running the App Locally

In one terminal, start the Rails server:

```bash
rails server
```

The app will be available at `http://localhost:3000`

## Connected Services

### Required for full functionality

- **Stripe** - Payment processing (development and production)
- **OAuth providers** - Google, GitHub, Facebook authentication

### Production only

- **AWS S3** - File storage (must finish configuration)
- **Amazon SES** - Email delivery (must finish configuration)
- **Google Analytics** - Usage tracking

## Running Tests

```bash
# All tests
rails test

# System tests (browser-based)
rails test:system

# Controller tests only
rails test test/controllers
```

## TODO

- Tests
- Code linting improvements
- Minor production setups (File storage and email delivery)
