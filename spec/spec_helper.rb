# frozen_string_literal: true

require "draft_matchers"
require "rspec-html-matchers"
require "webmock/rspec"
require "#{File.expand_path("../support/webmock", __FILE__)}"
require "#{File.expand_path("../support/json_output_formatter", __FILE__)}"
require "#{File.expand_path("../support/hint_formatter", __FILE__)}"

SPEC_ROOT = Pathname(__dir__).realpath.freeze

RSpec.configure do |config|
  config.color = true
  config.disable_monkey_patching!
  config.example_status_persistence_file_path = "./tmp/rspec-examples.txt"
  config.filter_run_when_matching :focus
  config.formatter = ENV.fetch("CI", false) == "true" ? :progress : :documentation
  config.order = :random
  config.pending_failure_output = :no_backtrace
  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.warnings = true

  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_doubled_constant_names = true
    mocks.verify_partial_doubles = true
  end
end

