class BirthdayValidator < ActiveModel::EachValidator
  def validate_each record, attribute, value
    return if valid_age value.to_date
    record.errors[attribute] << I18n.t("validators.birthday",
      min_year: Settings.min_birthday.to_date.year,
      max_year: (Date.today.year - Settings.min_age))
  end

  private

  def valid_age birthday
    birthday < Date.today && birthday >= Settings.min_birthday.to_date
  end
end
