# Be sure to restart your server when you modify this file.

# Add new inflection rules using the following format 
# (all these examples are active by default):
# ActiveSupport::Inflector.inflections do |inflect|
#   inflect.plural /^(ox)$/i, '\1en'
#   inflect.singular /^(ox)en/i, '\1'
#   inflect.irregular 'person', 'people'
#   inflect.uncountable %w( fish sheep )
# end
                                                                             

Time::DATE_FORMATS[:datetime_military] = '%Y-%m-%d %H:%M'
Time::DATE_FORMATS[:datetime]         = '%Y-%m-%d %H:%M'
Time::DATE_FORMATS[:time]              = '%I:%M%P'
Time::DATE_FORMATS[:time_military]     = '%H:%M%P'
Time::DATE_FORMATS[:datetime_short]    = '%m/%d %I:%M'