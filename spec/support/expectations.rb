# frozen_string_literal: true

require "rspec/expectations"

RSpec::Matchers.define :have_alert do |message|
  match do |page|
    expect(page).to have_flash :alert, message
  end
end

RSpec::Matchers.define :have_notice do |message|
  match do |page|
    expect(page).to have_flash :notice, message
  end
end

RSpec::Matchers.define :have_flash do |type, message|
  match do |page|
    @flash_element = Page::FlashMessage.new(type, message)

    expect(@flash_element).to exist
  end

  failure_message do |_page|
    unless @flash_element.type_exists?
      "geen flash element gevonden op de pagina, verwachtte #{type} met bericht: '#{message}'"
    else
      "verwachtte flash bericht met '#{message}', maar was '#{@flash_element.text}'"
    end
  end
end
