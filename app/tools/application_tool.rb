# frozen_string_literal: true

# Base class for all MCP tools in this app. Provides helpers shared across the
# family-tree query tools: resolving a person by id or slug, and serializing
# responses as JSON text for the MCP client.
class ApplicationTool < ActionTool::Base
  private

  # Resolve a Person from an id (integer), a friendly_id slug, or a display
  # name. Soft-deleted people are excluded (default paranoia scope).
  #
  # The first lookup matches an exact id/slug. If that misses, the identifier is
  # slugified (downcased, spaces/underscores -> hyphens, accents stripped) and
  # retried, so a human-readable name like "Emilia Setuko Sakamoto" or an
  # underscore variant like "rafael_yuki" resolves to the same person as the
  # canonical slug "emilia-setuko-sakamoto" / "rafael-yuki".
  def find_person(identifier)
    resolve_person(identifier) || resolve_person(slugify(identifier))
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
    candidate = identifier.to_s.parameterize.tr("_", "-")
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
