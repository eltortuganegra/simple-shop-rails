class User < ActiveRecord::Base
  USERNAME_MINIMUM_LENGTH = 3
  USERNAME_MAXIMUM_LENGTH = 15
  USERNAME_VALID_FORMAT_PATTERN = /\A\w+\z/
  PASSWORD_MINIMUM_LENGTH = 6
  EMAIL_VALID_FORMAT_PATTERN = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i

  has_one :setting

  validates :username,
    length: {
      minimum: USERNAME_MINIMUM_LENGTH,
      maximum: USERNAME_MAXIMUM_LENGTH,
    },
    format: {
      with: USERNAME_VALID_FORMAT_PATTERN,
      message: 'Username must content only alphanumeric and underscore characters.'
    }

  validates :username,
    uniqueness: true,
    on: :create

  validates :password,
    presence: true,
    length: {
      minimum: PASSWORD_MINIMUM_LENGTH
    },
    on: :create

    validates :password,
      presence: true,
      length: {
        minimum: PASSWORD_MINIMUM_LENGTH
      },
      allow_blank: true,
      on: :update


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
