module DoubanResources
  class Event
    attr_accessor :id, :category, :title, :uri, :summary, :city, :location
    
    def initialize(json)
      @json     = json
      obj       = JSON.load(json)
      
      @id        = obj['id']['$t']
      @city      = obj['db:location']['$t']
      @title     = obj['title']['$t']
      @uri       = obj['link'].detect {|h| h['@rel'] == 'self'}
      @uri       = @uri['@href'] if uri
      @homepage  = obj['link'].detect {|h| h['@rel'] == 'homepage'}
      @homepage  = @homepage['@href'] if homepage
      @bio       = obj['content']['$t']
      @icon      = obj['link'].detect {|h| h['@rel'] == 'icon'}
      @icon      = @icon['@href'] if icon
    end
  end
end