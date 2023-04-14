class GptController < ApplicationController
  require "openai"

  def chat
    text = params[:text]
    messages = [{ role: "system", content: prompt },
                { role: "user", content: text }]
    response = client.chat(
      parameters: {
          model: "gpt-3.5-turbo",
          messages: messages,
          temperature: 0.5
      })
    render json: response.to_json, status: 200
  end

  private

  def client
    @client ||= OpenAI::Client.new(access_token: ENV["OPENAI_API_KEY"])
  end

  def prompt
    text = "repeat after me:"
    prompt = URI.encode_www_form_component(text)
  end
end
