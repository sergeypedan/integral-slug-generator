# frozen_string_literal: true

require "integral/slug_generator/version"
require "cyrillizer"
require "securerandom"

module Integral
  module SlugGenerator
    class Error < StandardError; end

    require "securerandom"
    require "i18n"

    Cyrillizer.alphabet = Rails.root.join('lib', 'cyrillizer', 'russian.yml')

    def initialize(uniqueness_checker:, validation_checker: nil, separator: "-")
      @separator          = separator
      @uniqueness_checker = uniqueness_checker
      @validation_checker = validation_checker || lambda { |s| (s.to_s != "") && (s.size > 5) }
      fail ArgumentError, "uniqueness_checker must be a lambda / Proc" unless @uniqueness_checker.is_a? Proc
      fail ArgumentError, "validation_checker must be a lambda / Proc" unless @validation_checker.is_a? Proc
      fail ArgumentError, "provided separator (#{separator}) is too long" if separator.to_s.size > 2
    end

    def generate(full_name = nil)
      full_name.to_s == '' ? calculate_slug_with_no_text_input : calculate_slug_from_username(full_name)
    end


    # private

    def unique?(string)
      @uniqueness_checker.call string
    end

    def valid?(string)
      @validation_checker.call string
    end

    def slug_ok?(string)
      valid?(string) && unique?(string)
    end


    def calculate_slug_with_no_text_input
      loop do
        candidate = random_only
        break candidate if slug_ok?(candidate)
      end
    end


    def calculate_slug_from_username(full_name)
      slugified = slugify_full_name(full_name)
      return slugified if slug_ok?(slugified)

      loop do
        candidate = random_with_text(slugified)
        break candidate if slug_ok?(candidate)
      end
    end

    def random_with_text(text)
      [text, SecureRandom.hex(3)].join("-")
    end

    def random_only
      SecureRandom.hex(3)
    end

    def slugify_full_name(text)
      Cyrillizer.alphabet = Rails.root.join('lib', 'cyrillizer', 'russian.yml')
      text.gsub(/\s/, @separator).gsub(/_/, @separator).downcase.to_lat
    end

  end
end
