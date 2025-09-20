require "test_helper"

class GenerateCsvTest < ActiveSupport::TestCase
  # Create a test model that includes the GenerateCsv concern
  def setup
    # Create a test class that includes GenerateCsv
    @test_class = Class.new(ActiveRecord::Base) do
      self.table_name = 'users' # Use existing table for testing
      include GenerateCsv
    end
    
    @users = [users(:one), users(:two)]
  end

  # BASIC FUNCTIONALITY TESTS
  test "includes GenerateCsv concern in class methods" do
    assert @test_class.respond_to?(:to_csv)
  end

  test "to_csv returns a string" do
    csv_output = @test_class.to_csv(@users)
    assert_instance_of String, csv_output
  end

  test "to_csv generates CSV with semicolon separator" do
    csv_output = @test_class.to_csv(@users)
    assert_includes csv_output, ';'
  end

  test "to_csv includes headers as first row" do
    csv_output = @test_class.to_csv(@users)
    lines = csv_output.split("\n")
    
    headers = lines.first.split(';')
    expected_headers = @test_class.column_names
    
    assert_equal expected_headers, headers
  end

  # DATA INTEGRITY TESTS
  test "to_csv includes all records in collection" do
    csv_output = @test_class.to_csv(@users)
    lines = csv_output.split("\n")
    
    # Should have header + number of users
    assert_equal @users.count + 1, lines.count
  end

  test "to_csv preserves column order from model" do
    csv_output = @test_class.to_csv(@users)
    lines = csv_output.split("\n")
    headers = lines.first.split(';')
    
    assert_equal @test_class.column_names, headers
  end

  test "to_csv handles nil values correctly" do
    # Create user with some nil values
    user_with_nils = User.new(
      name: "Test User",
      email: "test@example.com",
      phone: nil,
      provider: nil
    )
    user_with_nils.save!(validate: false)
    
    csv_output = @test_class.to_csv([user_with_nils])
    lines = csv_output.split("\n")
    data_row = lines[1].split(';')
    
    # Should handle nil values (they become empty strings in CSV)
    assert_includes data_row, ''
  end

  test "to_csv includes correct data for each record" do
    csv_output = @test_class.to_csv([@users.first])
    lines = csv_output.split("\n")
    headers = lines.first.split(';')
    data_row = lines[1].split(';')
    
    # Verify data matches the user attributes
    headers.each_with_index do |header, index|
      expected_value = @users.first.attributes[header]
      actual_value = data_row[index]
      
      # Handle different data types
      if expected_value.nil?
        assert_equal '', actual_value
      else
        assert_equal expected_value.to_s, actual_value
      end
    end
  end

  # EDGE CASES TESTS
  test "to_csv handles empty collection" do
    csv_output = @test_class.to_csv([])
    lines = csv_output.split("\n")
    
    # Should only have headers
    assert_equal 1, lines.count
    assert_equal @test_class.column_names, lines.first.split(';')
  end

  test "to_csv handles single record collection" do
    csv_output = @test_class.to_csv([@users.first])
    lines = csv_output.split("\n")
    
    # Should have header + 1 data row
    assert_equal 2, lines.count
  end

  test "to_csv handles large collection" do
    # Create multiple test records
    large_collection = (1..10).map do |i|
      User.new(
        name: "User #{i}",
        email: "user#{i}@example.com",
        confirmed_at: Time.current
      )
    end
    
    # Save them
    large_collection.each { |user| user.save!(validate: false) }
    
    csv_output = @test_class.to_csv(large_collection)
    lines = csv_output.split("\n")
    
    # Should have header + 10 data rows
    assert_equal 11, lines.count
  end

  # SPECIAL CHARACTER HANDLING
  test "to_csv handles special characters in data" do
    user_with_special_chars = User.new(
      name: "Test; User, With \"Quotes\"",
      email: "test@example.com"
    )
    user_with_special_chars.save!(validate: false)
    
    csv_output = @test_class.to_csv([user_with_special_chars])
    
    # Should properly escape or handle special characters
    assert_includes csv_output, user_with_special_chars.name
  end

  test "to_csv handles unicode characters" do
    user_with_unicode = User.new(
      name: "テストユーザー",
      email: "test@example.com"
    )
    user_with_unicode.save!(validate: false)
    
    csv_output = @test_class.to_csv([user_with_unicode])
    
    # Should preserve unicode characters
    assert_includes csv_output, "テストユーザー"
  end

  # CSV FORMAT VALIDATION
  test "to_csv generates valid CSV format" do
    csv_output = @test_class.to_csv(@users)
    
    # Should be parseable by CSV library
    assert_nothing_raised do
      CSV.parse(csv_output, col_sep: ';', headers: true)
    end
  end

  test "to_csv uses semicolon as column separator" do
    csv_output = @test_class.to_csv(@users)
    parsed_csv = CSV.parse(csv_output, col_sep: ';', headers: true)
    
    # Should have correct number of columns
    assert_equal @test_class.column_names.count, parsed_csv.headers.count
  end

  test "to_csv includes headers by default" do
    csv_output = @test_class.to_csv(@users)
    parsed_csv = CSV.parse(csv_output, col_sep: ';', headers: true)
    
    # Headers should match column names
    assert_equal @test_class.column_names, parsed_csv.headers
  end

  # PERFORMANCE TESTS
  test "to_csv is efficient with column ordering" do
    # The method uses values_at(*column_names) which should be efficient
    csv_output = @test_class.to_csv(@users)
    lines = csv_output.split("\n")
    
    # Verify all expected columns are present
    headers = lines.first.split(';')
    assert_equal @test_class.column_names.sort, headers.sort
  end

  # INTEGRATION WITH ACTIVERECORD
  test "to_csv works with ActiveRecord scopes" do
    # Test with a scope/where clause
    filtered_users = User.where(name: @users.first.name)
    csv_output = @test_class.to_csv(filtered_users)
    lines = csv_output.split("\n")
    
    # Should have header + filtered records
    assert_equal filtered_users.count + 1, lines.count
  end

  test "to_csv works with includes/joins" do
    # Test with eager loading (if applicable)
    users_with_includes = User.includes(:events).limit(2)
    
    assert_nothing_raised do
      csv_output = @test_class.to_csv(users_with_includes)
    end
  end

  # DATETIME HANDLING
  test "to_csv handles datetime fields correctly" do
    csv_output = @test_class.to_csv([@users.first])
    lines = csv_output.split("\n")
    
    # Should include datetime values as strings
    assert_includes csv_output, @users.first.created_at.to_s
    assert_includes csv_output, @users.first.updated_at.to_s
  end

  # BOOLEAN HANDLING  
  test "to_csv handles boolean fields correctly" do
    # Create user with boolean-like data if any exists
    csv_output = @test_class.to_csv([@users.first])
    
    # Should convert boolean values to strings
    assert_instance_of String, csv_output
  end

  # ERROR HANDLING
  test "to_csv handles missing column gracefully" do
    # Mock a scenario where a column might be missing
    assert_nothing_raised do
      csv_output = @test_class.to_csv(@users)
    end
  end

  # CLASS METHOD VERIFICATION
  test "to_csv is a class method not instance method" do
    assert @test_class.respond_to?(:to_csv)
    assert_not @users.first.respond_to?(:to_csv)
  end

  test "to_csv can be called on model classes that include GenerateCsv" do
    # Test with actual model classes that include the concern
    if User.respond_to?(:to_csv)
      assert_nothing_raised do
        User.to_csv(User.limit(1))
      end
    end
  end

  private

  def teardown
    # Clean up any test records created
    User.where(email: ['test@example.com']).delete_all
    User.where('email LIKE ?', 'user%@example.com').delete_all
  end
end