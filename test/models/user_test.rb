require 'test_helper'

class UserTest < ActiveSupport::TestCase
  fixtures :users

  USERNAME_VALID_NOT_REGISTERED = 'new_user'
  USERNAME_INVALID_2_CHARACTERS = '12'
  USERNAME_INVALID_16_CHARACTERS = '1234567890123456'
  EMAIL_VALID_NOT_REGISTERED = 'thisemailsisnotregistered@themonkeyisland.com'
  EMAIL_INVALID_FORMAT = 'this.email@is.not@valid.'
  PASSWORD_VALID = '123456'
  PASSWORD_INVALID_5_CHARACTERS = '12345'

  setup do
    @new_user = User.new(
      username: USERNAME_VALID_NOT_REGISTERED,
      email: EMAIL_VALID_NOT_REGISTERED,
      password: PASSWORD_VALID,
      password_confirmation: PASSWORD_VALID
    )
  end

  test "Username must be equal or greater than 3 characters." do
    new_user = @new_user
    new_user.username = USERNAME_INVALID_2_CHARACTERS

    assert new_user.invalid?, "Username must be greater than or equal to 3 characters."
  end

  test "Username must be equal or less than 15 characters" do
    new_user = @new_user
    new_user.username = USERNAME_INVALID_16_CHARACTERS

    assert new_user.invalid?, "Username must be less than or equal to 15 characters."
  end

  test "Username must content only alphanumeric and underscore characters." do
    new_user = @new_user

    new_user.username = '!"·$%&/()=?¿* ç'
    assert new_user.invalid?, "Username must content only alphanumeric and underscore characters."

    new_user.username = '-.,;:Ç*^<>+|@#~½'
    assert new_user.invalid?, "Username must content only alphanumeric and underscore characters."

    new_user.username = '¬{[]}\\~"\''
    assert new_user.invalid?, "Username must content only alphanumeric and underscore characters."
  end

  test "Username must be unique" do
    guybrush = users(:Guybrush_Threepwood)
    new_user = @new_user
    new_user.username = guybrush.username

    assert new_user.invalid?, "Username must be unique."
  end

  test "Password must be equal or greater than 6 characters" do
    new_user = @new_user
    new_user.password = PASSWORD_INVALID_5_CHARACTERS
    new_user.password_confirmation = PASSWORD_INVALID_5_CHARACTERS

    assert new_user.invalid?, "Password must be equal or greater than 6 characters."
  end

  test "Email must be unique" do
    guybrush = users(:Guybrush_Threepwood)
    new_user = @new_user
    new_user.email = guybrush.email

    assert new_user.invalid?, "Email must be unique."
  end

  test "Email must have a valid email format" do
    new_user = @new_user
    new_user.email = EMAIL_INVALID_FORMAT

    assert new_user.invalid?, "Email must have a valid email format."
  end

end
