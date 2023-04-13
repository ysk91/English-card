class GptController < ApplicationController
  require "openai"
  # before_action :set_common_variable

  def chat
    # 最初のメッセージ
    messages = [{ role: "system", content: prompt }] if messages.blank?

    # ユーザーからのメッセージに対しての処理
    text = params[:text]
    messages << { role: "user", content: text }
    response = client.chat(
      parameters: {
          model: "gpt-3.5-turbo",
          messages: messages,
          temperature: 0.5
      })
    render json: response.to_json, status: 200

    # @chat = response.dig("choices", 0, "message", "content")
    # messages << { role: "assistant", content: @chat }
  end

  private

  def client
    @client ||= OpenAI::Client.new(access_token: ENV["OPENAI_API_KEY"])
  end

  def prompt
    prompt = "Please return the entered text as is."
    #   = << 'EOS'
    # 英単語学習ゲームへようこそ！
    # これから、英語検定5級レベルの英単語を1つずつ出題してください。
    # 私が日本語で答えますので、以下の条件に従い会話を進めてください。

    # ・正解の場合: 「正解！」を表示した後、次の英単語を出題
    # ・不正解の場合: 「不正解！」と正しい回答を表示した後、次の英単語を出題

    # また、5個のクイズに回答する毎に以下の処理をおこないます。
    # ・直近5問の正答数を「n / 5(nは正解数)」で表示し、2列のテーブルを作成する
    # ・テーブルの1列目には直近5問のうち間違った問題の英単語を表示する
    # ・テーブルの2列目には1列目の英単語の正しい日本語訳を表示する

    # 出題の際にヒントは不要です。
    # 良いですね？
    # それでは始めます。
    # EOS
  end
end
