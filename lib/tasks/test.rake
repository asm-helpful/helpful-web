if defined?(MiniTest)
  MiniTest::Rails::Testing.default_tasks << 'workers'
end