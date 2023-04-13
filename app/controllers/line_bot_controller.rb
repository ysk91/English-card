class LineBotController < ApplicationController
  def callback
    body = request.body.read
    events = client.parse_events_from(body)
    events.each do |event|
      case event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          # ここからGPT
          text = event.message["text"] # 受け取るメッセージ
          uri = URI("#{ENV['URI']}/chat?text=#{text}") # リクエスト先のURI
          response = Net::HTTP.get_response(uri) # APIにリクエストを送信
          response = JSON.parse(response.body) # 受け取ったJSONをパース
          chat = {
            type: "text",
            text: response.dig("choices", 0, "message", "content")
          } # LINEへ返すレスポンス
          client.reply_message(event['replyToken'], chat) # LINEへ返す
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
