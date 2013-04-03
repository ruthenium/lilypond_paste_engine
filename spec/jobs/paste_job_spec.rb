require "spec_helper"

describe PasteJob do
  before :all do
    Delayed::Worker.delay_jobs = false
  end

  after :all do
    Delayed::Worker.delay_jobs = true
  end

  after :each do
    Delayed::Job.destroy_all
    Paste.destroy_all
  end

  context "when valid :lilypond_text given" do
    it "sets generated paste data" do
      paste = FactoryGirl.create :paste_with_lilypond_text, :valid => true

      LilyHelpers.should_receive(:process_lilypond).once.and_call_original
      PasteJob.any_instance.should_receive(:success).once.and_call_original
      
      Delayed::Job.enqueue(PasteJob.new(paste.id))

      paste = Paste.find(paste.id)

      paste.lilypond.should_not be_blank
      paste.pdf.should_not be_blank
      paste.images.should_not be_empty

      paste.status.should == 'OK'
      paste.processed?.should be_true
      paste.proc_success?.should be_true

      paste.expires_at.should == 30.days.since(paste.created_at)
    end
  end

  context "when invalid :lilypond_text given" do
    it "marks paste as invalid" do
      paste = FactoryGirl.create :paste_with_lilypond_text, :valid => false

      LilyHelpers.should_not_receive(:mxml_to_lilypond)
      LilyHelpers.should_receive(:process_lilypond).once.and_call_original
      PasteJob.any_instance.should_receive(:success).once.and_call_original

      Delayed::Job.enqueue(PasteJob.new(paste.id))

      paste = Paste.find(paste.id)

      paste.status.should_not == "OK"
      paste.processed?.should be_true
      paste.proc_success?.should be_false
      paste.expires_at.should == 1.day.since(paste.created_at)
    end
  end

  context "when valid :mxml given" do
    it "sets generated paste data" do
      paste = FactoryGirl.create :paste_with_mxml, :valid => true
   
      LilyHelpers.should_receive(:mxml_to_lilypond).once.and_call_original
      LilyHelpers.should_receive(:process_lilypond).once.and_call_original
      PasteJob.any_instance.should_receive(:success).once.and_call_original

      Delayed::Job.enqueue(PasteJob.new(paste.id))

      paste = Paste.find(paste.id)

      paste.lilypond.should_not be_blank
      paste.pdf.should_not be_blank
      paste.images.should_not be_empty

      paste.status.should == 'OK'
      paste.processed?.should be_true
      paste.proc_success?.should be_true

      paste.expires_at.should == 30.days.since(paste.created_at)
    end
  end

  context "when invalid :mxml given" do
    it "marks paste as invalid" do
      paste = FactoryGirl.create(:paste_with_mxml, :valid => false)

      LilyHelpers.should_receive(:mxml_to_lilypond).once.and_call_original
      LilyHelpers.should_not_receive(:process_lilypond)
      PasteJob.any_instance.should_receive(:success).once.and_call_original

      Delayed::Job.enqueue(PasteJob.new(paste.id))

      paste = Paste.find(paste.id)

      paste.status.should_not == "OK"
      paste.processed?.should be_true
      paste.proc_success?.should be_false

      paste.expires_at.should == 1.day.since(paste.created_at)
    end
  end

  context "when :mxml and :lilypond both present in paste" do
    it "marks paste as invalid and successfully returns" do
      paste = FactoryGirl.build :paste_with_both
      paste.save(:validate => false)

      LilyHelpers.should_not_receive(:mxml_to_lilypond)
      LilyHelpers.should_not_receive(:process_lilypond)
      PasteJob.any_instance.should_receive(:success).and_call_original

      lambda {Delayed::Job.enqueue(PasteJob.new(paste.id))}.should_not raise_error

      paste = Paste.find(paste.id)
      paste.status.should_not == "OK"
      paste.processed?.should be_true
      paste.proc_success?.should be_false
      paste.expires_at.should == 1.day.since(paste.created_at)
    end
  end

  context "when no data present in paste" do
    it "marks paste as invalid and successfully returns" do
      paste = Paste.new(:lilypond_text => "")
      paste.save(:validate => false)

      LilyHelpers.should_not_receive(:mxml_to_lilypond)
      LilyHelpers.should_not_receive(:process_lilypond)
      PasteJob.any_instance.should_receive(:success).once.and_call_original

      lambda {Delayed::Job.enqueue(PasteJob.new(paste.id))}.should_not raise_error

      paste = Paste.find(paste.id)
      paste.status.should_not == "OK"
      paste.processed?.should be_true
      paste.proc_success?.should be_false

      paste.expires_at.should == 1.day.since(paste.created_at)
    end
  end

  context "when not existing paste given" do
    it "simply successfully returns" do
      LilyHelpers.should_not_receive(:mxml_to_lilypond)
      LilyHelpers.should_not_receive(:process_lilypond)
      PasteJob.any_instance.should_receive(:success).once.and_call_original
      lambda { Delayed::Job.enqueue(PasteJob.new(12345)) }.should_not raise_error
    end
  end

end