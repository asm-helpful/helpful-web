Analytics = Segment::Analytics.new({
  write_key: ENV.fetch('SEGMENT_WRITE_KEY', ''),
  on_error: Proc.new { |status, msg| print msg }
})
