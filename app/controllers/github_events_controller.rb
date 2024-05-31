class GithubEventsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def webhook
    request.body.rewind

    service = GithubWebhookService.new(**webhook_params)
    service.process_event

    head :ok
  end

  private

  def webhook_params
    {
      payload: request.body.read,
      signature: request.env['HTTP_X_HUB_SIGNATURE']
    }
  end
end
