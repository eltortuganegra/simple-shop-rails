class User < ActiveRecord::Base
  USERNAME_MINIMUM_LENGHT = 3
  USERNAME_MAXIMUM_LENGHT = 15
  USERNAME_VALID_FORMAT_PATTERN = /\A\w+\z/
  PASSWORD_MINIMUM_LENGHT = 6
  EMAIL_VALID_FORMAT_PATTERN = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i

  validates :username,
    length: {
      minimum: USERNAME_MINIMUM_LENGHT,
      maximum: USERNAME_MAXIMUM_LENGHT,
    },
    format: {
      with: USERNAME_VALID_FORMAT_PATTERN,
      message: 'Username must content only alphanumeric and underscore characters.'
    }

  validates :username,
    uniqueness: true,
    on: :create

  validates :password,
    length: {
      minimum: PASSWORD_MINIMUM_LENGHT
    }

  validates :email,
     format: {
       with: EMAIL_VALID_FORMAT_PATTERN,
       message: 'Email must be have a valid email.'
     }

  validates :email,
     uniqueness: true,
     on: :create

  has_secure_password
end
