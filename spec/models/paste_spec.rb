require 'spec_helper'

describe Paste do
  before :each do
    Paste.delete_all
  end

  after :all do
    Paste.destroy_all
  end

  it "is invalid if :mxml and :lilypond_text both are empty" do
    p = FactoryGirl.build :paste
    p.should_not be_valid
  end

  it "is invalid if :mxml and :lilypond_text are both present" do
    p = FactoryGirl.build :paste_with_both
    p.should_not be_valid
  end

  it "is valid if and only if one of :lilypond_text and :mxml is set" do
    p = FactoryGirl.build :paste_with_lilypond_text
    p.should be_valid

    p = FactoryGirl.build :paste_with_mxml
    p.should be_valid
  end

  it "allows only .mxml, .xml, .musicxml extensions for :mxml" do
    p = FactoryGirl.build :paste_with_illegal_mxml
    p.should_not be_valid
  end

  it "generates unique :visible_id when created" do
    p = FactoryGirl.build :paste_with_lilypond_text
    p.visible_id.should be_nil
    p.save
    p.visible_id.should_not be_nil
    p.visible_id.length.should == 6
    Paste.count(:id, :conditions => {:visible_id => p.visible_id}).should == 1
  end

  it "sets :expires_at field when created" do
    p = FactoryGirl.create :paste_with_lilypond_text
    p.expires_at.should_not be_nil
  end

  # it "responds to aadmin_mxml_not_null_in" do # activeadmin
  #   Paste.should respond_to(:aadmin_mxml_not_null_in)
  # end

end
