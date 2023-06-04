require "test_helper"

class MailerMailerTest < ActionMailer::TestCase
  test "person_created" do
    mail = MailerMailer.person_created
    assert_equal "Person created", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "person_updated" do
    mail = MailerMailer.person_updated
    assert_equal "Person updated", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "couple_created" do
    mail = MailerMailer.couple_created
    assert_equal "Couple created", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "couple_updated" do
    mail = MailerMailer.couple_updated
    assert_equal "Couple updated", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

  test "child_created" do
    mail = MailerMailer.child_created
    assert_equal "Child created", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
