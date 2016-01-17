class Contact
  attr_accessor :email
  attr_accessor :name
  attr_accessor :message

  def initialize params
    @email = params[:email]
    @name = params[:name]
    @message = params[:message]
  end
end
