require 'spec_helper'
require "fileutils"


describe LilyHelpers do
  it "responds to mxml_to_lilypond" do
    LilyHelpers.should respond_to(:mxml_to_lilypond)
  end

  it "responds to process_lilypond" do
    LilyHelpers.should respond_to(:process_lilypond)
  end

  describe :mxml_to_lilypond do
    it "accepts a file-like object (with #read method defined)" do
      lambda {LilyHelpers.mxml_to_lilypond(:foo)}.should raise_error(NoMethodError)
      # also should specify the file and stringio objects here.
    end

    context "when valid MusicXML file given" do
      before :all do
        @f = FactoryGirl.attributes_for(:paste_with_mxml)[:mxml]
      end

      after :all do
        @f = nil
      end

      it "returns converted lilypond as string" do
        result = LilyHelpers.mxml_to_lilypond(@f)
        result.should be_an_instance_of(String)
        result.should_not be_empty
      end
    end

    context "when invalid MusicXML file given" do
      before :all do
        @f = FactoryGirl.attributes_for(:paste_with_mxml, :valid => false)[:mxml]
      end

      after :all do
        @f = nil
      end

      it "returns nil" do
        LilyHelpers.mxml_to_lilypond(@f).should be_nil
      end
    end
  end

  describe :process_lilypond do
    before :each do
      @dir = Dir.mktmpdir
    end

    after :each do
      FileUtils::rm_rf(@dir)
    end

    it "accepts a file-like object and two strings" do
      lambda {LilyHelpers.process_lilypond(:foo)}.should raise_error
      lambda {LilyHelpers.process_lilypond(:foo, :bar)}.should raise_error
      lambda {LilyHelpers.process_lilypond(:foo, :bar, :baz)}.should raise_error
      # need test:
      # cwd should exist
      # file and stringio
    end

    context "when valid Lilypond file given" do
      before :all do
        @f = FactoryGirl.attributes_for(:paste_with_lilypond_file)[:lilypond]
        @basename = File.basename(@f, ".ly")
      end

      after :all do
        @f = @basename = nil
      end

      it "returns a Hash, where keys are :png and :pdf and values are sorted Arrays of paths of files in tmp dir" do
        result = LilyHelpers.process_lilypond(@f, @basename, @dir)

        result.should_not be_nil

        result.should be_an_instance_of(Hash)
        result.should have_key(:pdf)
        result.should have_key(:png)

        result[:pdf].should be_an_instance_of(Array)
        result[:png].should be_an_instance_of(Array)

        result[:pdf].should_not be_empty
        result[:png].should_not be_empty

        result[:pdf].sort.should == result[:pdf]
        result[:png].sort.should == result[:png]

        result[:pdf].each do |pdf|
          File.exists?(pdf).should be_true
          File.dirname(pdf).should == @dir
          File.basename(pdf, ".pdf").should == @basename
        end

        result[:png].each do |png|
          File.exists?(png).should be_true
          File.dirname(png).should == @dir
          File.basename(png, ".png").should == @basename
        end
      end
    end

    context "when invalid lilypond file given" do
      before :all do
        @f = FactoryGirl.attributes_for(:paste_with_lilypond_file, :valid => false)[:lilypond]
        @basename = File.basename(@f, ".ly")
      end

      after :all do
        @f = @basename = nil
      end

      it "returns nil" do
        LilyHelpers.process_lilypond(@f, @basename, @dir).should be_nil
      end
    end
  end
end