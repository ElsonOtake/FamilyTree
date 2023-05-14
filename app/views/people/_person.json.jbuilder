json.extract! person, :id, :name, :gender, :alive, :birth, :death, :description, :created_at, :updated_at
json.url person_url(person, format: :json)
