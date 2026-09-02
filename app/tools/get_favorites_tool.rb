# frozen_string_literal: true

# Get the current user's favorite people: name, kanji, gender, birth/death
# dates, age and description for each person they've favorited.
class GetFavoritesTool < ApplicationTool
  tool_name 'get_favorites'
  description "Get the current user's favorite people."

  annotations(
    title: 'Get favorites',
    read_only_hint: true,
    open_world_hint: false
  )

  def call
    return render(error: 'No authenticated user for this request.') unless Current.user

    people = Current.user.favorite_people.order(:name)

    render(people: people.map { |person| PersonPresenter.detail(person) })
  end
end
