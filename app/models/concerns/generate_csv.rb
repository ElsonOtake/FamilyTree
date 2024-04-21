module GenerateCsv
  extend ActiveSupport::Concern
  require 'csv'

  class_methods do
    def to_csv(collection)
      CSV.generate(col_sep: ';', headers: true) do |csv|
        csv << column_names
        collection.each do |record|
          csv << record.attributes.values_at(*column_names)
        end
      end
    end
  end
end
