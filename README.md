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
- **Search & Filtering**: Filter by name, gender, birth/death dates, alive status
- **Soft Deletes**: Records are preserved for audit trails
- **Activity Logging**: All changes are tracked with timestamps and user info
- **File Uploads**: Avatar images via Active Storage with S3 support
- **OAuth Support**: Sign in with Google

## Tech Stack

- **Ruby**: 3.4.5
- **Rails**: 8.0.0
- **Database**: PostgreSQL
- **Frontend**: Hotwire (Turbo + Stimulus), Bulma CSS
- **Authentication**: Devise with OmniAuth
- **Authorization**: Pundit + Rolify
- **File Storage**: Active Storage (S3 in production)

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

3. Setup the database:
   ```bash
   bin/rails db:create
   bin/rails db:migrate
   bin/rails db:seed
   ```

4. Start the development server:
   ```bash
   bin/dev
   ```

5. Visit `http://localhost:3000`

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
bin/rails db:seed       # Load seed data
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
yarn build          # Build JavaScript assets
yarn build:css      # Build CSS from Sass
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
| `get_age` | Current age (handles partial dates and deceased people) |

Tools live in [`app/tools/`](app/tools/), share a serializer in
[`app/mcp/person_presenter.rb`](app/mcp/person_presenter.rb), and the server is configured in
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
| **Admin** | Full access including CSV exports |

## Internationalization

The app supports three languages:
- English (`en`)
- Japanese (`ja`)
- Portuguese (`pt`)

Users can set their preferred language in their profile. Translations are stored in `config/locales/`.

## Environment Variables

For production, configure:

- `DATABASE_URL` - PostgreSQL connection string
- `RAILS_MASTER_KEY` - For credentials decryption
- `AWS_ACCESS_KEY_ID` - S3 access key
- `AWS_SECRET_ACCESS_KEY` - S3 secret key
- `AWS_BUCKET` - S3 bucket name
- `AWS_REGION` - S3 region
- `GOOGLE_CLIENT_ID` - Google OAuth client ID
- `GOOGLE_CLIENT_SECRET` - Google OAuth secret

## Deployment

The app is configured for deployment on Fly.io. See `fly.toml` for configuration.

```bash
fly deploy
```

Migrations run automatically via the release command.

## License

This project is available as open source.
