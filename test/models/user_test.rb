require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'user with a valid email should be valid' do
    user = User.new(email: 'hamda@gmail.com', password_digest: 'my-password')
    assert user.valid?
  end

  test 'user with invalid email should be invalid' do
    user = User.new(email: 'hamada', password_digest: 'mayada')
    assert_not user.valid?
  end

  test 'user with taken email should be invalid' do
    other_user = users(:one)
    user = User.new(email: other_user.email, password_digest: 'hamada')
    assert_not user.valid?
  end

  test 'destroy user should also destroy linked products' do
    assert_difference('Product.count', -1) do
      users(:one).destroy
    end
  end
end
