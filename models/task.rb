require 'mechanize'
require 'sqlite3'

class Task
  class << self
    attr_reader :all

    def update(user_agent)
      @all.each { |t| t.update(user_agent) }
    end
  end

  @all = []

  attr_reader :name, :url, :agent

  DEFAULT_LOGGED_IN = Proc.new do |page|
    page.links.any? { |l| l.uri && l.uri.path == '/logout' }
  end

  def initialize(name, url, logged_in = DEFAULT_LOGGED_IN)
    @name, @url, @logged_in = name, url, logged_in
    @agent = Mechanize.new
    self.class.all.push self
  end

  def favicon
    "#@url/favicon.ico"
  end

  def complete?
    @complete
  end

  def update(user_agent)
    @agent.cookie_jar.clear!
    cookies(user_agent).each { |c| @agent.cookie_jar.add! c }
    page = @agent.get(@url)
    puts '************************************'
    p page.links.map(&:uri)
    puts '************************************'
    p page.links.map(&:uri).map {|a| a && [a.path, a.class] }
    @complete = @logged_in.call page
    #@complete = true
  end

  def cookies(user_agent)
    case user_agent
    when :chrome then Cookie.chrome_cookies
    when :firefox then Cookie.firefox_cookies
    else raise "Unsupported browser: #{user_agent}.  Please use Chrome or FireFox."
    end
  end
end

