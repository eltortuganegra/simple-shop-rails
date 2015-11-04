require 'test_helper'

class ApplicationControllerTest < ActionController::TestCase
  setup do
    @lechuck = users(:LeChuck)
  end

  test "should save the id if the 'lechuck' user in to the session variable" do
    @controller.send(:login, @lechuck.id)

    assert session[:user_id] == @lechuck.id, 'Lechuck not found.'
  end

  test "should return true if lechuck is logged" do
    session[:user_id] = @lechuck.id

    assert @controller.send(:is_user_loggin?) , 'Lechuck is not logged!'
  end

  test "should logout to lechuck" do
    session[:user_id] = @lechuck.id
    @controller.send(:logout)

    assert ! session.has_key?(:user_id), 'Lechuck is logged yet!'
  end
end
