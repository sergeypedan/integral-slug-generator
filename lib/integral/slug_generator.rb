# frozen_string_literal: true

require "integral/slug_generator/version"

require "cyrillizer"
require "securerandom"

module Integral
  class SlugGenerator

    Cyrillizer.alphabet = File.expand_path('../slug_generator/russian.yml', __FILE__)

    def initialize(uniqueness_checker:, validation_checker: nil, generator: nil, separator: "-")
      @generator          = generator || lambda { SecureRandom.hex(3) }
      @separator          = separator
      @uniqueness_checker = uniqueness_checker
      @validation_checker = validation_checker || lambda { |s| (s.to_s != "") && (s.size > 5) }
      fail ArgumentError, "generator must be a lambda / Proc. We expect somehting like `lambda { SecureRandom.hex(3) }` (which is default)." unless @generator.is_a? Proc
      fail ArgumentError, "uniqueness_checker must be a lambda / Proc. We expect somehting like `lambda { |string| User.exists?(slug: string) }`." unless @uniqueness_checker.is_a? Proc
      fail ArgumentError, "validation_checker must be a lambda / Proc. We expect somehting like `lambda { |string| string.size > 5 }.`" unless @validation_checker.is_a? Proc
      fail ArgumentError, "provided separator (#{separator}) is too long" if separator.to_s.size > 2
    end

    def generate(full_name = nil)
      full_name.to_s == '' ? calculate_slug_with_no_text_input : calculate_slug_from_username(full_name)
    end


    private

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
        candidate = @generator.call
        break candidate if slug_ok?(candidate)
      end
    end

    def calculate_slug_from_username(full_name)
      slugified = slugify_full_name(full_name)
      return slugified if slug_ok?(slugified)

      loop do
        candidate = [text, @generator.call].join(@separator)
        break candidate if slug_ok?(candidate)
      end
    end

    def slugify_full_name(text)
      text.gsub(/\s/, @separator).gsub(/_/, @separator).downcase.to_lat
    end

  end
end
