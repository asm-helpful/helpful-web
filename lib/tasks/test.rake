if defined?(MiniTest)
  %w(workers serializers).each do |task|
    MiniTest::Rails::Testing.default_tasks << task
  end
end
