# Family Tree

A Ruby on Rails application for managing family trees with support for multiple languages, dark mode, and collaborative editing.

## Features

- **Family Tree Management**: Create and manage people, couples, and parent-child relationships
- **Partial Date Support**: Birth/death dates can be incomplete (year only, month/day only, etc.)
- **Multi-Language Support**: English, Japanese, and Portuguese
- **Dark Mode**: Toggle between light and dark themes
- **User Roles**: Bronze (view), Silver (create/edit), Gold (delete), Admin (full access)
- **Favorites**: Save frequently accessed people for quick access
- **Birthday Tracking**: View upcoming birthdays with smart date calculations
- **Printable Charts**: Downloadable ancestor, descendant (with spouses), and descendants-only pedigree charts (PDF), with gender-specific silhouettes for people without a photo and per-user settings for generation depth and pet inclusion
- **AI Assistant Access**: A built-in [MCP](https://modelcontextprotocol.io) server lets an AI assistant answer natural-language questions about the tree (see below)
- **Search & Filtering**: Filter by name, gender, birth/death dates, alive status
- **Soft Deletes**: Records are preserved for audit trails
- **Activity Logging**: All changes are tracked with timestamps and user info
- **File Uploads**: Avatar images via Active Storage; crop a person out of a larger photo when uploading
- **OAuth Support**: Sign in with Google

## Tech Stack

- **Ruby**: 3.4.5
- **Rails**: 8.0.2
- **Database**: PostgreSQL
- **Frontend**: Hotwire (Turbo + Stimulus), Tailwind CSS
- **Authentication**: Devise with OmniAuth
- **Authorization**: Pundit + Rolify
- **File Storage**: Active Storage (Tigris, Fly.io's S3-compatible object storage, in production)
- **Email**: Action Mailer over Gmail SMTP in production

## Live Demo

- [Live Demo Link](https://elsonotake-familytree.onrender.com/)

Log in via `Google OAuth` or using the username `admin@demo.com` with the password `password`.

## Getting Started

### Prerequisites

- Ruby 3.4.5
- PostgreSQL 9.4+
- Node.js and Yarn

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/ElsonOtake/FamilyTree.git
   cd FamilyTree
   ```

2. Install dependencies:
   ```bash
   bundle install
   yarn install
   ```

3. Configure environment variables:
   ```bash
   cp .env.example .env
   ```
   At minimum, set `DATABASE_DEV_USERNAME` / `DATABASE_DEV_PASSWORD` for your local PostgreSQL.

4. Set up the database. The seed generates a small **fictional** family tree with Faker — this repository ships **no real personal data**:
   ```bash
   bin/rails db:create
   bin/rails db:migrate
   bin/rails db:seed
   ```

5. Start the development server:
   ```bash
   bin/dev
   ```

6. Visit `http://localhost:3000` and sign in with the seeded demo account (**`admin@demo.com`** / **`password`**).

## Development Commands

### Server
```bash
bin/dev              # Start Rails server + JS/CSS watchers (recommended)
bin/rails server     # Start Rails server only
bin/rails console    # Rails console for debugging
```

### Database
```bash
bin/rails db:migrate    # Run pending migrations
bin/rails db:seed       # Generate a fictional demo tree with Faker
bin/rails db:reset      # Drop, create, migrate, and seed
```

### Testing
```bash
bin/rails test              # Run all tests except system tests
bin/rails test:system       # Run system tests only
bin/rails test:all          # Run all tests including system tests
```

### Assets
```bash
yarn build          # Build JavaScript assets (esbuild)
yarn build:css      # Build CSS with Tailwind
```

## Data Model

### Core Entities

- **Person**: Individuals in the family tree (name, gender, birth/death dates, avatar)
- **Couple**: Relationships between two people (marriage/separation dates)
- **Child**: Links children to their parent couples

### Relationships

```
Person A ──╮
           ├── Couple ──> Children (People)
Person B ──╯
```

A child is always linked to a **Couple** (two parents). A person can have children from multiple couples.

### Key Methods

```ruby
# Person instance methods
person.father          # Find father
person.mother          # Find mother
person.siblings        # All siblings
person.mates           # All partners/spouses
person.children        # All children from all relationships

# Couple instance methods
couple.person1         # First parent
couple.person2         # Second parent
couple.people          # Children of this couple

# Couple class methods
Couple.couple(person1, person2)  # Find couple relationship between two people
Couple.mates(person_id)          # All partners of a person
Couple.children(person_id)       # All children of a person (from all couples)
```

## MCP Server (AI Assistant Access)

The app exposes a [Model Context Protocol](https://modelcontextprotocol.io) server so an AI assistant can answer
natural-language questions about the tree ("who are Maria's parents?", "how old is John?", "who are
someone's siblings?"). It is built with the [`fast-mcp`](https://github.com/yjacquin/fast-mcp) gem and
mounted directly in Rails — the tools call the existing `Person`/`Couple` models, so there is no separate API to maintain.

### Endpoint & authentication

- **Endpoint:** `https://<your-app>/mcp` (SSE stream at `/mcp/sse`, messages at `/mcp/messages`)
- **Auth:** per-user bearer token. Each user opts in from the **MCP access** page (in the navbar's *More*
  menu), which generates a personal `mcp_token`. Send it as `Authorization: Bearer <token>`.
- Access is read-only. Tokens can be regenerated or revoked at any time.

### Tools

| Tool | Question it answers |
|------|---------------------|
| `find_person` | Search people by name/kanji to get their id |
| `get_person` | Full details for one person (gender, dates, age) |
| `get_parents` | Father, mother, and recorded parents |
| `get_children` | All children across relationships |
| `get_siblings` | Other children of the same parents |
| `get_partners` | Spouses/partners with marriage & separation dates |
| `get_cousins` | First cousins (children of the parents' siblings) |
| `get_age` | Current age (handles partial dates and deceased people) |
| `get_birthdays` | People with a birthday today/tomorrow/this week/this month |
| `get_anniversaries` | Couples with a wedding anniversary in a given period |

Tools live in [`app/tools/`](app/tools/), share serializers in
[`app/mcp/person_presenter.rb`](app/mcp/person_presenter.rb) and
[`app/mcp/couple_presenter.rb`](app/mcp/couple_presenter.rb), and the server is configured in
[`config/initializers/fast_mcp.rb`](config/initializers/fast_mcp.rb). Tests are in
[`test/tools/`](test/tools/), [`test/integration/mcp_endpoint_test.rb`](test/integration/mcp_endpoint_test.rb),
and the token lifecycle in [`test/models/user_mcp_token_test.rb`](test/models/user_mcp_token_test.rb).

### Connecting a client

```jsonc
// Example MCP client config (SSE transport)
{
  "mcpServers": {
    "family-tree": {
      "url": "https://<your-app>/mcp/sse",
      "headers": { "Authorization": "Bearer <your-mcp-token>" }
    }
  }
}
```

## User Roles

| Role | Permissions |
|------|-------------|
| **Bronze** | View people and couples (default) |
| **Silver** | Create and edit people/couples |
| **Gold** | Delete people/couples |
| **Admin** | Full access, plus the ActiveAdmin panel (restore soft-deleted records, browse the audit log) |

## Internationalization

The app supports three languages:
- English (`en`)
- Japanese (`ja`)
- Portuguese (`pt`)

Users can set their preferred language in their profile. Translations are stored in `config/locales/`.

## Environment Variables

Copy `.env.example` to `.env` and fill it in — it is grouped into local-development and production sections. Highlights:

**Local development**

- `DATABASE_DEV_USERNAME` / `DATABASE_DEV_PASSWORD` - PostgreSQL credentials for the development and test databases (required)
- `GOOGLE_ID` / `GOOGLE_SECRET` - Google OAuth login (optional; omit to disable "Sign in with Google")
- `CONTACT_EMAIL` - contact address shown on the About page and in email footers
- `MAILER_FROM` - from/sender address for outgoing mail

**Production**

- `DATABASE_URL` - PostgreSQL connection string
- `RAILS_MASTER_KEY` - decrypts `config/credentials.yml.enc` (or provide the `config/master.key` file)
- `SECRET_KEY_BASE` - Rails secret key base
- `GMAIL_USERNAME` / `GMAIL_APP_PASSWORD` - Gmail SMTP for outgoing email
- `AWS_ACCESS_KEY_ID` / `AWS_SECRET_ACCESS_KEY` / `AWS_ENDPOINT_URL_S3` / `BUCKET_NAME` - S3-compatible object storage (Tigris)
- `APP_URL` - Production URL if not on Render
- `DEMO_MODE` - Demonstration or Production mode

> On Fly.io, the storage variables (`AWS_*`, `BUCKET_NAME`) are set automatically by `fly storage create` (Tigris).

## Deployment

The app is configured for deployment on Fly.io or Render.

**Fly.io**

See `fly.toml` for configuration.

```bash
fly deploy
```

**Render**

See `/bin/render-build.sh` for configuration.

Migrations run automatically via the release command.

## License

This project is available as open source.
