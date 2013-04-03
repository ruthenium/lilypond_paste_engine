Delayed::Worker.destroy_failed_jobs = false
Delayed::Worker.max_attempts = 2
Delayed::Worker.max_run_time = 3.minutes


# WARNING!
# The next line is needed to initialize worker when invoking "rake jobs:work"
# instead of "RAILS_ENV=env scripts/delayed_job start"
# Otherwise logger object will became unavailable and uninitialized in the tasks
# See also https://github.com/collectiveidea/delayed_job/issues/279

unless Rails.env == "test"
  Delayed::Worker.logger ||= Logger.new(File.join(Rails.root, 'log', 'delayed_job.log'))
  Delayed::Worker.logger.level = Rails.logger.level
end