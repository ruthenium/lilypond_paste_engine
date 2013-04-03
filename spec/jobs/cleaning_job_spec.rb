require "spec_helper"

describe CleaningJob do
  before :all do
    Delayed::Worker.delay_jobs = false
  end

  after :all do
    Delayed::Worker.delay_jobs = true
  end

  after :each do
    Delayed::Job.destroy_all
  end

  it "clears all pastes expired before this moment" do
    (0..(rand(100)+10)).each do |i|
      p = FactoryGirl.create(:paste_with_lilypond_text)
      p.expires_at = i.days.ago
      p.save
    end

    Delayed::Job.enqueue(CleaningJob.new)

    Paste.count.should == 0
  end

  it "sends :clean_cached_files! to CarrierWave" do
    CarrierWave.should_receive(:clean_cached_files!).once.and_call_original

    Delayed::Job.enqueue(CleaningJob.new)
  end
end