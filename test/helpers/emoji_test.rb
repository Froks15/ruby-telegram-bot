require 'test_helper'

class EmojiHelperTest < ActionView::TestCase
    include EmojiHelper

    test "RU flag" do
        assert_equal create_flag_emoji(country_code: 'ru'), "🇷🇺"
    end

    test "US flag" do
        assert_equal create_flag_emoji(country_code: 'us'), "🇺🇸"
    end

    test "AM flag" do
        assert_equal create_flag_emoji(country_code: 'am'), "🇦🇲"
    end

    test "nil flag" do
        assert_equal create_flag_emoji(country_code: nil), "❓"
    end

    test "empty flag" do
        assert_equal create_flag_emoji(country_code: ""), "❓"
    end

    test "temperature <= 0" do
        assert_equal create_temperature_emoji(temperature: 0), "❄"
    end

    test "temperature >= 20" do
        assert_equal create_temperature_emoji(temperature: 20), "☀"
    end

    test "temperature < 20 and > 0" do
        assert_equal create_temperature_emoji(temperature: 5), "☁"
    end

    test "nil temperature" do
        assert_equal create_temperature_emoji(temperature: nil), "❓"
    end

    test "empty temperature" do
        assert_equal create_temperature_emoji(temperature: ""), "❓"
    end
end