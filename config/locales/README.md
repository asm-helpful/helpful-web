## Creating a translation for Helpful

A translation for Helpful can be created by copying config/locales/en.yml and saving it as [your locale].yml, for example fr.yml in the same folder.

Translate all strings in your newly created file. Be sure to check for context "archive" might mean "to archive" in one place, but "an archive" in another.

### Devise translations
A large part of the login system uses devise which comes with translations through the devise-i18n gem, you won't have to translate any of those strings and they'll automatically be included.

### Testing your translation
You can test-drive your translation by adding
	
	config.i18n.default_locale = :[your locale]

in config/application.rb