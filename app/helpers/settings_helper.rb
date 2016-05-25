module SettingsHelper

  def get_url_for_disable_account_link confirmation_code
    settings_disable_account_confirmation_url + '?confirmation_code=' + confirmation_code.to_s
  end
end
