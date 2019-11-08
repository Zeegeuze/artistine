# frozen_string_literal: true

module Page
  class FlashMessage < Page::Base
    def initialize(type, message)
      @type = type
      @message = message
    end

    def exists?
      type_exists? && text.include?(@message)
    end

    # bestaat dit soort ding op de pagina ongeacht de message?
    def type_exists?
      flash_element.present?
    end

    def text
      flash_element.text
    end

    private

    def flash_element
      @flash_element ||= page.all(".flash_#{@type}").first
    end
  end
end
