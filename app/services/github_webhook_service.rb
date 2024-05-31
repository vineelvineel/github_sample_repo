class GithubWebhookService
  OPENED = 'opened'.freeze
  ESTIMATE_REGEX = /Estimate: \d+ days/

  def initialize(payload:, signature:)
    @payload = payload
    @signature = signature
  end

  def process_event
    return if invalid_signature?

    @event = parsed_event
    create_comment if issue_opened?
  end

  private

  attr_reader :payload, :signature, :event

  def parsed_event
    JSON.parse(payload)
  end

  def issue
    event['issue']
  end

  def issue_opened?
    event['action'] == OPENED && issue.present?
  end

  def invalid_signature?
    !valid_signature?
  end

  def valid_signature?
    expected_signature = "sha1=#{OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha1'), webhook_secret, payload)}"
    Rack::Utils.secure_compare(expected_signature, signature)
  end

  def webhook_secret
    Rails.application.credentials.github.webhook_secret
  end

  def create_comment
    return if issue_contains_estimate?

    post_comment(
      issue_number: issue['number'],
      repo_full_name: event.dig('repository', 'full_name')
    )
  end

  def issue_contains_estimate?
    issue['body']&.match?(ESTIMATE_REGEX)
  end

  def post_comment(issue_number:, repo_full_name:)
    client.add_comment(
      repo_full_name,
      issue_number,
      'Please provide an estimate in the format: `Estimate: X days`.'
    )
  end

  def client
    @client ||= Octokit::Client.new(access_token: Rails.application.credentials.github.token)
  end
end
