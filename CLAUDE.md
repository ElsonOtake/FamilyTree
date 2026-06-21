# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Ruby on Rails 7.0.4 application for managing family trees, built with:
- PostgreSQL database
- Hotwire (Turbo & Stimulus) for reactive UI without complex JavaScript frameworks
- Bulma CSS framework
- Multi-language support (English, Japanese, Portuguese)
- Soft deletes via paranoia gem
- File uploads via Active Storage with S3 support in production

## Essential Development Commands

### Server and Development
```bash
bin/dev              # Start Rails server + JS/CSS watchers (recommended)
bin/rails server     # Start Rails server only
bin/rails console    # Rails console for debugging
```

### Database
```bash
bin/rails db:create     # Create development and test databases
bin/rails db:migrate    # Run pending migrations
bin/rails db:seed       # Load seed data
bin/rails db:reset      # Drop, create, migrate, and seed
```

### Testing
```bash
bin/rails test              # Run all tests except system tests
bin/rails test:system       # Run system tests only
bin/rails test:all          # Run all tests including system tests
bin/rails test test/models/person_test.rb  # Run specific test file
```

### Assets
```bash
yarn build          # Build JavaScript assets
yarn build:css      # Build CSS from Sass
```

## Architecture Overview

### Core Domain Models

1. **Person** - Individuals in the family tree
   - Uses friendly_id for SEO-friendly URLs (slug field)
   - Supports partial dates (birth/death dates can have null year/month/day)
   - Gender options: 'M', 'F', 'P', 'X'
   - Soft deletes with paranoia (deleted_at field)
   - Has avatar attachment via Active Storage

2. **Couple** - Relationships between two people
   - Automatically orders person1_id < person2_id to prevent duplicates
   - Has many children through CouplesChildrenPeople join table
   - Tracks marriage_date and separation_date

3. **User** - Application users with Devise authentication
   - Multi-language support (locale field)
   - OAuth support via OmniAuth (provider/uid fields)
   - Email confirmation required

### Key Design Patterns

- **Authorization**: Pundit policies in `app/policies/`
- **Soft Deletes**: Records have `deleted_at` timestamp instead of being destroyed
- **I18n**: All UI text goes through Rails i18n, routes are localized
- **Stimulus Controllers**: Interactive UI in `app/javascript/controllers/`
- **Form Objects**: Complex forms use form objects pattern
- **Service Objects**: Business logic extracted to service classes

### MCP Server

- An MCP (Model Context Protocol) server lets AI assistants query the tree in natural language. Built with the `fast-mcp` gem, mounted at `/mcp`.
- **Tools** live in `app/tools/` (`find_person`, `get_person`, `get_parents`, `get_children`, `get_siblings`, `get_partners`, `get_age`); they reuse the existing `Person`/`Couple` methods. Shared serializer: `app/mcp/person_presenter.rb`. Server config + custom auth transport: `config/initializers/fast_mcp.rb`.
- **Auth**: per-user bearer token (`User#mcp_token`, opt-in via the *MCP access* page). The transport sets `Current.user` after validating the token. It is inserted before `Warden::Manager` so its 401s aren't swallowed by Devise.
- Tools are **read-only**. When adding a tool, subclass `ApplicationTool`, return a JSON string via `render(...)`, and add a test under `test/tools/`.

### Frontend Architecture

- **Hotwire/Turbo**: Most interactions are Turbo frames/streams, not full page loads
- **Stimulus**: JavaScript behavior attached via data-controller attributes
- **Bulma**: CSS framework classes, customized in `app/assets/stylesheets/`
- **No React/Vue**: This is a server-rendered Rails app with Hotwire enhancements

### Testing Approach

- Minitest (not RSpec) for unit and integration tests
- System tests use Capybara with Selenium
- Test fixtures in `test/fixtures/` (not FactoryBot)
- Policy tests verify authorization rules

### Deployment

- Deployed to Fly.io (see fly.toml)
- PostgreSQL database (version 9.4+ required for birthday filtering functionality)
- S3 for file storage in production
- Release command runs migrations automatically

## Important Conventions

1. **Partial Dates**: When working with birth/death dates, remember they can be partial (missing year/month/day). Use the custom date handling methods.

2. **Soft Deletes**: Never call `destroy!` directly. Records should be soft-deleted. Use `deleted_at` scopes.

3. **I18n**: All user-facing text must use I18n translations. Add new keys to all three locales (en, ja, pt).

4. **Turbo**: Prefer Turbo frames/streams over full page redirects. Test with Turbo enabled.

5. **Couples**: Always ensure person1_id < person2_id when creating couples to prevent duplicates.

6. **File Uploads**: Use Active Storage variants for images. Don't process images synchronously.

## Common Development Tasks

### Adding a new field to Person
1. Create migration: `bin/rails generate migration AddFieldToPeople field_name:type`
2. Update model validations and methods in `app/models/person.rb`
3. Update form in `app/views/people/_form.html.erb`
4. Update show view in `app/views/people/show.html.erb`
5. Add translations to `config/locales/*.yml`
6. Update tests in `test/models/person_test.rb`

### Working with Stimulus Controllers
- Controllers are in `app/javascript/controllers/`
- Register new controllers in `app/javascript/controllers/index.js`
- Use data attributes in views: `data-controller="name" data-name-target="element"`

### Debugging Database Issues
- Check for soft-deleted records: `Person.with_deleted`
- Verify couple ordering: `Couple.where("person1_id > person2_id")`
- Check partial dates: `Person.where(birth_date_year: nil)`