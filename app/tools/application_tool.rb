# frozen_string_literal: true

# Base class for all MCP tools in this app. Provides helpers shared across the
# family-tree query tools: resolving a person by id or slug, and serializing
# responses as JSON text for the MCP client.
class ApplicationTool < ActionTool::Base
  private

  # Resolve a Person from an id (integer), a friendly_id slug, or a name.
  # Soft-deleted people are excluded (default paranoia scope). Tried in order:
  #   1. exact id/slug
  #   2. the slugified identifier (so "Emilia Setuko Sakamoto" / "rafael_yuki"
  #      reach the canonical "emilia-setuko-sakamoto" / "rafael-yuki")
  #   3. a name search, used only when it matches exactly one person, so a
  #      partial name like "Satiye Sakamoto" resolves to "Satiye Sakamoto Otake"
  #      while an ambiguous one (e.g. "Sakamoto") is left to find_person.
  def find_person(identifier)
    resolve_person(identifier) ||
      resolve_person(slugify(identifier)) ||
      resolve_by_name(identifier)
  end

  # Resolve via name search, but only when the match is unambiguous.
  def resolve_by_name(identifier)
    matches = Person.search_by_name(identifier).limit(2).to_a
    matches.first if matches.size == 1
  end

  # Look up by exact id/slug, returning nil instead of raising when not found.
  def resolve_person(identifier)
    return nil if identifier.blank?

    Person.friendly.find(identifier)
  rescue ActiveRecord::RecordNotFound
    nil
  end

  # Convert an arbitrary identifier into the canonical slug form. Returns nil
  # when it is already identical (so we don't repeat the same failed lookup).
  def slugify(identifier)
    candidate = identifier.to_s.parameterize.tr('_', '-')
    candidate == identifier.to_s ? nil : candidate
  end

  # Serialize a hash/array result to a JSON string. fast-mcp wraps a returned
  # String as a text content block, which is what MCP clients read.
  def render(data)
    JSON.generate(data)
  end

  # Standard "person not found" payload.
  def person_not_found(identifier)
    render(error: "No person found for identifier #{identifier.inspect}")
  end
end
