Analytics = AnalyticsRuby

if ENV.key?('SEGMENT_SECRET') && !Rails.env.test?
	Analytics.init({
	  secret: ENV['SEGMENT_SECRET'],
	  on_error: Proc.new { |status, msg| print msg }
	})
end
