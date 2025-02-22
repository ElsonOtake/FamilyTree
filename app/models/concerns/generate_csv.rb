# frozen_string_literal: true

# This module is used to generate CSV files from the database.
# It is included in the models that need to generate CSV files.
# The method to_csv generates a CSV file with the column names as headers and the records as rows.
# The column separator is set to ';' and the headers are set to true.
# The method uses the column_names method to get the column names of the model.
# The method then iterates over the collection of records and adds the attributes of each record as a row in the CSV file.
# The method returns the generated CSV file as a string.
# The method can be called on the model class to generate
#
#
# Não está carregando o valor do campo deleted_at
#
#
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
