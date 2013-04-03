require './config/boot' # we must be in a project root
require './config/environment'
require 'clockwork'

module Clockwork
	every 2.hours, 'Queueing cleanup job' do
		Delayed::Job.enqueue CleaningJob.new, :queue => 'paste-cleaning'
	end
end