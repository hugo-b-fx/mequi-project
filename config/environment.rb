# Load the Rails application.
require_relative "application"

# Silence Rails.application.secrets deprecation warning during initialization
# This is a known Rails 7.1 issue that triggers even when using credentials
original_stderr = $stderr
$stderr = StringIO.new

begin
  # Initialize the Rails application.
  Rails.application.initialize!
ensure
  # Capture any output and filter the secrets deprecation warning
  captured = $stderr.string
  $stderr = original_stderr
  filtered = captured.lines.reject { |line| line.include?("Rails.application.secrets") }
  $stderr.write(filtered.join) if filtered.any?
end
