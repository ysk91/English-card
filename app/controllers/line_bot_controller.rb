class LineBotController < ApplicationController
  def callback
    body = request.body.read
    events = client.parse_events_from(body)
    events.each do |event|
      case event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          # ユーザーからのメッセージが「出勤なう」だった場合のみにメッセージを返す
          if event.message["text"] == "出勤なう"
            uri = URI('https://qiita-api.vercel.app/api/trend')
            response = Net::HTTP.get_response(uri)
            response = JSON.parse(response.body)
            # LINEへ返すレスポンス
            message = []
            # トレンド上位5記事のみ抽出
            5.times {|i|
              hash = {}
              hash[:type] = "text"
              hash[:text] = response[i]["node"]["linkUrl"]
              message.push(hash)
            }
            client.reply_message(event['replyToken'],  message)
          end
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
