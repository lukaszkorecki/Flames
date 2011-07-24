require 'spec_helper'

require 'spec_helper'

describe Formatter do
  it "should work" do
    lambda {Formatter.new}.should_not raise_error
  end

  context "formatting" do
    before(:each) do
      @inst = Formatter.new
    end
    it "returns a warning string if its an unknown type" do
      @inst.format('lolz').should include 'Unknown type!'
    end

    it "returns a formatted string for a message" do
      m = {
        'type' => 'TextMessage',
        'body' => 'lol',
        'user' => {
          'name' => 'test'
        }
      }

      @inst.format(m).should match /\<.*test.*> lol/
    end

    it "formats paste message" do
      m = {
        'type' => 'PasteMessage',
        'body' => 'lol',
        'user' => {
          'name' => 'test'
        }
      }
      @inst.format(m).should match /\<.*test.*>\nlol/
    end

    it "formats join message" do
      m = {
        'type' => 'EnterMessage',
        'user' => {
          'name' => 'test'
        }
      }
      @inst.format(m).should match /test.*joined the room/
    end
    it "formats leave message" do
      m = {
        'type' => 'KickMessage',
        'user' => {
          'name' => 'test'
        }
      }
      @inst.format(m).should match /test.*left the room/
    end

  end
end
