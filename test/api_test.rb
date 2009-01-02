require 'test/unit'
require File.dirname(__FILE__)+'/test_helper'

class ApiTest < Test::Unit::TestCase
  include Freebase::Api
  def test_find_single_record
    record = mqlread(:id => "/en/the_polyphonic_spree", :name => nil)
    assert_instance_of FreebaseResult, record
    assert_equal "The Polyphonic Spree", record.name
  end
  def test_find_raw_data
    data = mqlread({:id => "/en/the_polyphonic_spree", :name => nil}, :raw => true)
    assert_instance_of Hash, data
    assert_equal "The Polyphonic Spree", data['name']
  end
  def test_find_multiple_records
    data = mqlread([{:type => '/music/artist', :name => nil, :'name~=' => '^Tori '}])
    assert_instance_of Array, data
    assert_instance_of FreebaseResult, data.first
    assert data.map{|artist| artist.name}.include?('Tori Amos')
  end
  def test_find_multiple_raw_data
    data = mqlread([{:type => '/music/artist', :name => nil, :'name~=' => '^Tori '}], :raw => true)
    assert_instance_of Array, data
    assert_instance_of Hash, data.first
    assert data.map{|artist| artist['name']}.include?('Tori Amos')
  end
  
  def test_uncursored_find
    # mqlread will limit our result set to 100 elements per request by default
    assert_equal 100, mqlread([{:type => '/chemistry/chemical_element'}]).length
  end
  def test_cursored_find
    # By using a cursor, we can get all 117 chemical elements (plus a few undiscovered extras)
    assert mqlread([{:type => '/chemistry/chemical_element'}], :cursor => true).length >= 117
  end
end