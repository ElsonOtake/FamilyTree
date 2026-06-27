# frozen_string_literal: true

# Base class for all MCP tools in this app. Provides helpers shared across the
# family-tree query tools: resolving a person by id or slug, and serializing
# responses as JSON text for the MCP client.
class ApplicationTool < ActionTool::Base
  private

  # Resolve a Person from an id (integer) or friendly_id slug (string).
  # Soft-deleted people are excluded (default paranoia scope).
  # Slugs use hyphens, but underscores are tolerated as a fallback so callers
  # can pass either separator (e.g. "rafael_yuki" resolves to "rafael-yuki").
  def find_person(identifier)
    Person.friendly.find(identifier)
  rescue ActiveRecord::RecordNotFound
    normalized = identifier.to_s.tr("_", "-")
    return nil if normalized == identifier.to_s

    begin
      Person.friendly.find(normalized)
    rescue ActiveRecord::RecordNotFound
      nil
    end
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
