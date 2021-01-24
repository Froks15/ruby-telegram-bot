module EmojiHelper
    def create_flag_emoji(country_code: nil)
        begin
            country_code = country_code.upcase
            flagOffset = 0x1F1E6
            asciiOffset = 0x41
            firstChar = country_code[0].ord - asciiOffset + flagOffset
            secondChar = country_code[1].ord - asciiOffset + flagOffset
            emoji = [firstChar, secondChar].pack("U*")
            return emoji
        rescue
            return "❓"
        end
    end

    def create_temperature_emoji(temperature: nil)
        begin
            case
            when temperature <= 0
                return "❄"
            when temperature >= 20
                return "☀"
            else
                return "☁"
            end
        rescue
            return "❓"
        end
    end
end