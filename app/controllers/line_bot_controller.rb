class LineBotController < ApplicationController
  require 'uri'

  def callback
    body = request.body.read
    events = client.parse_events_from(body)
    events.each do |event|
      case event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          text = URI.encode_www_form_component(event.message["text"])
          uri = URI("#{ENV['URI']}/chat?text=#{text}")
          response = Net::HTTP.get_response(uri)
          response = JSON.parse(response.body)
          chat = {
            type: "text",
            text: response.dig("choices", 0, "message", "content")
          }
          client.reply_message(event['replyToken'], chat)
        end
      end
    end
  end

  private

  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }
  end
end
