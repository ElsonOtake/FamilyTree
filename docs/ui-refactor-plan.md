# UI Refactor Plan — Bulma → Tailwind CSS + Pedigree PDF

Branch: `feature/ui-refactor-tailwind`

## 1. Goals

1. Replace **Bulma** with **Tailwind CSS** across the whole app.
2. Redesign the views freely (new layouts, new pages, drop dead code) while **keeping every existing capability**.
3. Preserve all functionality: name search (+ autocomplete), person details, parents / siblings / children / couples sections, birthdays, anniversaries data, favorites, dark mode, i18n (en/ja/pt), Devise auth, admin/roles/MCP-access pages, ActiveAdmin.
4. Keep "add / edit person" and all CRUD (couples, children) working through Turbo.
5. **New feature:** export a **genealogical tree chart (up to 5 generations) as a PDF**.

Non-goals: changing the data model, the MCP tools, or business logic. This is a presentation-layer refactor plus one additive feature.

## 2. Current state (as-is)

- **Rails 8 / Ruby 3.4.5 / PostgreSQL**, Hotwire (Turbo + Stimulus).
- **Asset pipeline:** `cssbundling-rails` compiling `app/assets/stylesheets/application.bulma.scss` (Bulma 0.9.4 + bulma-divider) via `sass`; `jsbundling-rails` bundling `app/javascript/application.js` via `esbuild`. Watched by `Procfile.dev` (`web` / `js` / `css`).
- **Icons:** external Font Awesome **kit `<script>`** in the layout **plus** the `font-awesome-sass` gem (redundant; the external script is a CSP/perf liability).
- **Dark mode:** custom `data-theme` attribute + a `dark_mode_controller` Stimulus controller **plus ~120 lines of inline `<style>`/`<script>` hacks in the layout** to force the mobile navbar colors. This is the ugliest part and Tailwind's `dark:` variant deletes it entirely.
- **Stimulus controllers:** `dark_mode`, `favorites`, `tabs`, `stimulus_controller` (generic modal open/close), `index`.
- **Turbo usage:** modals for new/edit couple, new child, edit person (Turbo Frames + `*.turbo_stream.erb`); autocomplete for child/mate search; favorites toggle; flash via turbo stream.
- **Views** (~40 ERB): `people/` (index, show, form, birthdays, `_person`, `_mate`, `_child`, `_icon`, `_table`, search partials), `couples/`, `children/`, `pages/` (about, statistics), `users/`, `devise/`, `layouts/`, `shared/`.
- **ActiveAdmin** mounted at `/admin` with its own `active_admin.scss` (independent of Bulma; must keep its own pipeline).
- **Localized routes** (pt slugs: `individuos`, `casais`, `filhos`).
- **Person relationship API already present:** `father`, `mother`, `siblings`, `mates`, `children`, `couples`, `cousins`, plus date/age/birthday helpers and (from recent work) `search_by_name`, birthday/anniversary scopes.

## 3. Target architecture

### 3.1 Toolchain
- Keep **cssbundling-rails + esbuild + yarn** (no need to introduce the standalone tailwindcss-rails gem since Node is already here).
- Add **Tailwind CSS v4** (`tailwindcss` + `@tailwindcss/cli`, `@tailwindcss/forms`, `@tailwindcss/typography`).
- New entry `app/assets/stylesheets/application.tailwind.css` with `@import "tailwindcss";`, a `@theme` block (brand colors, gender accent colors), and `@layer components` for reusable classes (`.btn`, `.btn-primary`, `.card`, `.badge`, `.field`, `.input`, `.avatar`).
- `build:css` script → `tailwindcss -i app/assets/stylesheets/application.tailwind.css -o app/assets/builds/application.css --minify`. `Procfile.dev` unchanged in shape (still a `css` watcher with `--watch`).
- **Dark mode:** Tailwind `dark` variant with the **class strategy** (`@custom-variant dark`). `dark_mode_controller` toggles `class="dark"` on `<html>`, persists to `localStorage`, and an inline head snippet applies it pre-paint to avoid FOUC. All the layout hacks are deleted.
- **Icons: DECIDED → inline SVG Heroicons.** Drop the external FA kit script and the `font-awesome-sass` gem. Add a small `icon(name, **opts)` helper (or `_icon` partial) that emits inline Heroicons SVG using `currentColor` so it themes with dark mode. Migrate every `<i class="fas ...">` to the helper.

### 3.2 ActiveAdmin
ActiveAdmin keeps its own `active_admin.scss` and Sass build. We retain `sass` **only** for that file (Tailwind handles everything else). Documented so Bulma removal doesn't break `/admin`.

### 3.3 Component approach
Plain ERB partials + a small `@layer components` vocabulary (keeps markup readable without a component framework). **ViewComponent is a stretch/optional** — only if partials get unwieldy. Redesign latitude (per request) means we can consolidate the two near-duplicate search partials, replace the Bulma modal with a Tailwind dialog, and introduce new shared partials (`_page_header`, `_person_badge`, `_relationship_card`, `_empty_state`).

## 4. Functionality parity checklist (must survive)

- [ ] Name search on index (Ransack + Pagy pagination + sort links).
- [ ] Autocomplete search for child / mate (Turbo Frame, debounce Stimulus).
- [ ] Person show: card + parents / siblings / spouse(s) / children.
- [ ] Add/remove couple (modal, Turbo Stream) and child (modal, Turbo Stream).
- [ ] Edit person / edit couple (modal, Turbo Stream).
- [ ] New person form: avatar upload, partial dates (year/month/day nullable), gender (M/F/P/X), kanji, alive flag, description.
- [ ] Birthdays page (upcoming, grouped past/today/upcoming).
- [ ] Favorites toggle (Stimulus + Turbo).
- [ ] Dark mode toggle (persisted, no FOUC).
- [ ] CSV download (`people#download`).
- [ ] Statistics + About pages.
- [ ] Users index / roles / MCP-access pages.
- [ ] Devise: sign in / up / edit / confirmations / passwords / unlocks / OmniAuth button.
- [ ] i18n across en / ja / pt on every rebuilt view.
- [ ] ActiveAdmin still styled and functional.

Each item gets a **Capybara system test** (smoke level) written in Phase 0 so parity is verifiable after the port.

## 5. Redesign opportunities (allowed by request)

- **New home/dashboard** (`pages#home` or people index hero): quick search, counts (living/deceased/unknown), upcoming birthdays & anniversaries, favorites, "add person" CTA.
- **Redesigned person page**: hero header (avatar, name, kanji, dates, age, alive badge), relationship cards in a responsive grid, and a **"View 5-gen tree (PDF)"** button.
- **Tree explorer (HTML)** *(optional stretch)*: an on-screen interactive pedigree (Stimulus) as a companion to the PDF.
- **Delete cruft**: the inline layout `<style>/<script>`, redundant FA kit, duplicated search partials, unused Bulma-only helpers.
- **Consistent empty states, badges, and buttons** via component classes.

## 6. New feature — 5-generation pedigree PDF

### 6.1 Scope — DECIDED → descendant chart
- **Descendant tree** for a focal person, up to **5 generations** (focal → children → grandchildren → …). Fans out through the person's couples and their `children`.
- Each node: name (+ kanji), birth–death (partial-date aware), age/lifespan; couples shown as paired nodes where useful.
- Handles people with multiple couples (children grouped per couple), childless leaves, and soft-deleted exclusion; cycle-safe.
- Renderer is written direction-agnostic so an **ancestor pedigree** variant can be added later via a param.

### 6.2 Tech choice
- **Prawn** (pure-Ruby PDF). Rationale: no headless Chrome needed on Fly.io (Grover/puppeteer would require a Chromium buildpack), deterministic vector layout, easy connector lines. Add gems: `prawn`, `prawn-table` (optional).
- Rejected: `wicked_pdf`/wkhtmltopdf (unmaintained), Grover (Chrome dependency, heavier deploy).

### 6.3 Design
- **Service `Pedigree::Chart`** — pure Ruby: given a root `Person` and `generations: 5`, builds a tree of nodes (`{person, generation, slot, position}`), recursively resolving `father`/`mother`, tolerant of cycles/soft-deletes.
- **Layout `Pedigree::Layout`** — computes x/y box coordinates. Left-to-right pedigree: generation = column (x), recursive vertical split for y. Chooses **A3 landscape** (or A4 with smaller boxes) and paginates if a generation overflows.
- **Renderer `Pedigree::Pdf`** (Prawn) — draws rounded node boxes, text (name/dates/age), and elbow **connector lines** parent→child. Reuses existing `Person` date/age formatters. Localized labels via i18n.
- **Avatars in PDF**: optional stretch (embed Active Storage variant); default off to keep it fast and dependency-light.

### 6.4 Wiring
- Route: `GET /individuos/:id/arvore.pdf` (localized) → `people#pedigree`.
- Controller action authorizes via Pundit (`show?`), builds the chart, `send_data pdf.render, filename: "arvore-<slug>.pdf", type: "application/pdf"`.
- **"Download 5-generation tree (PDF)"** button on the person page.
- Optional: `?generations=3..5` and `?direction=ancestors|descendants` params (validated).
- Consider a spinner/`target=_blank`; generation for ≤31 nodes is fast (synchronous, no job needed).

### 6.5 Tests
- `Pedigree::Chart` unit tests (depth, missing parents, soft-deleted excluded, cycle safety).
- `Pedigree::Layout` coordinate tests (no overlap, generation columns).
- Controller/integration test: PDF renders (200, `application/pdf`, non-empty) for a person with a multi-gen tree and for a childless/parentless person.
- i18n label presence for the three locales.

## 7. Phased execution

**Phase 0 — Safety net**
- Write Capybara smoke tests for the parity checklist (§4) against the current Bulma UI so behavior is pinned before redesign.
- Capture reference screenshots of key pages.

**Phase 1 — Tailwind toolchain**
- Add Tailwind v4 + plugins; create `application.tailwind.css`, `@theme`, base/component layers; update `build:css`; configure content globs; dark-mode class strategy + no-FOUC head snippet; decide icon strategy. App still renders (Bulma + Tailwind can co-exist briefly behind a flag).

**Phase 2 — Layout & shared kit**
- Rebuild `application.html.erb` (remove hacks), responsive **navbar** (hamburger via Stimulus), `flash`, **modal/dialog**, and component classes (`btn/card/badge/field/input/avatar`). Migrate `_icon` to SVG.

**Phase 3 — People**
- index (search/filter/sort/pagination/table + optional card view), show (hero + relationship cards + PDF button), `_person`, `_mate`, `_child`, form (avatar, partial dates), birthdays, search autocomplete partials, favorites.

**Phase 4 — Couples & children**
- couples index/new/edit/`_form`/`_couple`, children `_form`, all `*.turbo_stream.erb`, modal parity.

**Phase 5 — Pages, auth, users**
- about, statistics (charts/cards), Devise views, users/roles/mcp_access. Optional new dashboard/home.

**Phase 6 — Remove Bulma**
- Drop `bulma`, `bulma-rails`, `bulma-divider`, `application.bulma.scss`; prune package.json/Gemfile; keep `sass` for ActiveAdmin only. Verify no `is-*`/Bulma classes remain (grep gate).

**Phase 7 — Pedigree PDF**
- Add `prawn`; implement `Pedigree::{Chart,Layout,Pdf}`, route, controller action, policy, button, i18n, tests.

**Phase 8 — QA & ship**
- Full `bin/rails test` + `test:system`; manual pass across 3 locales, dark/light, mobile/desktop; verify every Turbo flow; deploy preview on Fly; visual diff vs Phase 0 screenshots.

## 8. Risks & mitigations

- **ActiveAdmin CSS coupling** → keep its Sass build; don't route AA through Tailwind.
- **Turbo modal/stream parity** → the Bulma `is-active` modal must be re-expressed in Tailwind while keeping `stimulus_controller` open/close and the same DOM ids/targets used by `*.turbo_stream.erb`. Test each stream.
- **Dark-mode FOUC** → pre-paint head snippet reading `localStorage` before CSS.
- **Icon migration churn** → do it once in `_icon`/helper; avoid scattering SVGs.
- **PDF on Fly** → Prawn avoids Chrome; no buildpack changes.
- **Partial dates & missing ancestors in PDF** → reuse model formatters; render "Unknown" slots.
- **Scope creep from redesign latitude** → parity checklist + Phase-0 tests are the guardrail; redesign is visual, behavior stays green.
- **Big PR** → land phase-by-phase (stacked PRs) rather than one mega-PR where possible.

## 9. Deliverables

- Tailwind-based UI replacing Bulma, all §4 functionality intact, redesigned per §5.
- New pedigree PDF export (§6).
- Updated tests (Phase 0 smoke + Pedigree units/integration).
- Removed dead code (inline hacks, redundant FA kit, Bulma).
- Updated docs (this file + README/CLAUDE.md notes on the new toolchain and PDF feature).
</content>
