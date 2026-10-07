# frozen_string_literal: true

ActiveAdmin.register Event do
  menu priority: 2

  actions :index

  preserve_default_filters!
  remove_filter :resource_type

  index download_links: [:csv]
end
