Delayed::Worker.max_attempts = 3
Delayed::Worker.logger = Logger.new(File.join(Rails.root, 'log', 'delayed_job.log'))
Delayed::Worker.raise_signal_exceptions = :term
Delayed::Worker.sleep_delay = 18000