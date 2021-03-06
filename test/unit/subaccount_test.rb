require 'test_helper'

class SubaccountTest < ActiveSupport::TestCase
   setup do
     @account = Emailaccount.new
     @account.name = "test2"
     @account.email = "test2@example.ch"
     @account.save
     @subaccount = ProfileId.new
     @subaccount.emailaccount = @account
  end
  test "test download" do
    lastget = @subaccount.time_of_last_ok
    @subaccount.downloaded
    assert lastget < @subaccount.time_of_last_ok
  end
end
