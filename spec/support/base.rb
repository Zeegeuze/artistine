# frozen_string_literal: true

require Rails.root.join("spec/support/page/base")
Dir[Rails.root.join("spec/support/page/support/*.rb")].each { |f| require f }
