require 'test_helper'

# Tests for the fileCreator module
# Needs 3 emailaccounts in the fixtures called "hans", "juerg" and "max" - please don't delete them!
#
# Author::    Dominique Rahm
# License::   Distributes under the same terms as Ruby

class FileCreatorTest < ActiveSupport::TestCase
  setup do
    @hans = emailaccounts(:hans)
    @juerg = emailaccounts(:juerg)
    @max = emailaccounts(:max)
  end
  
  test "html text" do
    testString = FileCreator::html("true")
    assert_match("pref(\"mail.default_html_action\", 2);", testString)
    assert_match("user_pref(\"mail.identity.id1.compose_html\", true);", testString)
  end
  
  test "quote text" do
    testString = FileCreator::quote("0")
    assert_match("user_pref(\"mail.identity.id1.reply_on_top\", 0);", testString)
  end
  
  test "signature_style text" do
    testString = FileCreator::signature_style("false")
    assert_match("user_pref(\"mail.identity.id1.sig_bottom\", false);", testString)
  end
  
  test "signature text" do
      testString = FileCreator::signature("This is just a simple signature")
      assert_match("user_pref(\"mail.identity.id1.htmlSigFormat\", true);", testString)
      assert_match("user_pref(\"mail.identity.id1.htmlSigText\", \"This is just a simple signature\");", testString)
    end
  
  test "complete file path" do
      filePath = FileCreator::completeZipPath @hans
      id = @hans.id
      assert_match("profiles/#{id}_profile.zip", filePath)
  end
  
  test "is not a validKey" do
    assert !(FileCreator::validKey? :test)
  end
  
  test "should raise Emailaccount nil" do
    assert_raise (RuntimeError){ FileCreator::createNewZip nil } 
  end
  
  test "should raise Preferences nil" do
    assert_raise (RuntimeError){ FileCreator::createNewZip @hans } 
  end
  
  test "create Zip" do
    zip_file_content = ""
    FileCreator::createNewZip @max
    assert FileTest.exist?("public/profiles/#{@max.id}_profile.zip")
    Zip::ZipFile.open( "public/profiles/#{@max.id}_profile.zip" )do
      |zipfile| 
      assert (zipfile.get_entry("user.js"))
      zip_file_content = zipfile.read("user.js") 
    end
    assert_match("user_pref(\"mail.identity.id1.htmlSigText\", \"Max Muster's signature\");", zip_file_content)
  end
  
  test "config file with empty preferences" do
      testString = FileCreator::getConfig @juerg
      assert @juerg.preferences.empty?
  end
  
  test "complete config file" do
      assert !(@max.preferences.empty?)
      testString = FileCreator::getConfig @max
      
      #HTML 
      assert_match("pref(\"mail.default_html_action\", 1);", testString)
 		  assert_match("user_pref(\"mail.identity.id1.compose_html\", false);", testString)
 		  
 		  #Quote
 		  assert_match("user_pref(\"mail.identity.id1.reply_on_top\", 2);", testString)
 		  
 		  #Signature_style
     	assert_match("user_pref(\"mail.identity.id1.sig_bottom\", true);", testString)
    
      #Signature
      assert_match("user_pref(\"mail.identity.id1.htmlSigText\", \"Max Muster's signature\");", testString)
   end
   
end