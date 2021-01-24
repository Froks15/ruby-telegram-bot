class TelegramWebhooksController < Telegram::Bot::UpdatesController
    include Telegram::Bot::UpdatesController::MessageContext
    include EmojiHelper

    around_action :with_locale
  
    def start!(*)
      respond_with :message, text: t('.content')
    end
  
    def help!(*)
      respond_with :message, text: t('.content')
    end
  
    def message(message)
      begin
        address = message["text"]

        client = OpenWeather::Client.new
        Geocoder.configure(language: locale_for_update)
        
        geocoder = Geocoder.search(address).first

        if geocoder.nil?
          return respond_with :message, text: t(
            'geocoder.not_found.content'
          )
        end

        city_name = geocoder.display_name
        country_emoji = create_flag_emoji(country_code: geocoder.country_code)
        daily_weather = client.one_call(geocoder.coordinates[0], geocoder.coordinates[1])
        today_weather = daily_weather.daily.first

        morning_temperature = today_weather.temp.morn_c.round
        day_temperature = today_weather.temp.day_c.round
        evening_temperature = today_weather.temp.eve_c.round

        morning_emoji = create_temperature_emoji(temperature: morning_temperature)
        day_emoji = create_temperature_emoji(temperature: day_temperature)
        evening_emoji = create_temperature_emoji(temperature: evening_temperature)

        respond_with :message, text: t(
          '.content', 
          user_name: from['first_name'],
          morning_temperature: morning_temperature,
          day_temperature: day_temperature,
          evening_temperature: evening_temperature,
          morning_emoji: morning_emoji,
          day_emoji: day_emoji,
          evening_emoji: evening_emoji,
          city_name: city_name,
          country_emoji: country_emoji
        )
      rescue => e
        respond_with :message, text: t(
          'errors.unknow_error'
        )
      end
    end
  
    def action_missing(action, *_args)
      if action_type == :command
        respond_with :message,
          text: t('telegram_webhooks.action_missing.command', command: action_options[:command])
      end
    end

    private

    def with_locale(&block)
      I18n.with_locale(locale_for_update, &block)
    end

    def locale_for_update
      if from
        from["language_code"].to_sym 
      elsif chat
        I18n.default_locale
      end
    end
end