# frozen_string_literal: true

# require "best_in_place/test_helpers"
require 'capybara/dsl'

module Page
  class Base
    include Rails.application.routes.url_helpers
    include Capybara::DSL
    # include BestInPlace::TestHelpers

    def has_purr?(text)
      has_css?(".purr", text: text)
    end

    # methode om in een js modal te klikken
    # wacht tot de knop verdwijnt om verder te gaan
    def click_modal_button(label)
      within ".modal" do
        button = find_button(label)
        button.click
      end

      has_no_css?(".modal", visible: true)
    end
  end
end
