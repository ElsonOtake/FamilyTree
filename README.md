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
