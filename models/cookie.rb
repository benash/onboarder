require 'tmpdir'

class Cookie
  def self.chrome_cookies
    db_path =
      "#{Dir.home}/Library/Application Support/Google/Chrome/Default/Cookies"

    Dir.mktmpdir do |dir|
      FileUtils.copy(db_path, dir)
      db = SQLite3::Database.new db_path
      rows = db.execute 'select * from cookies'
      rows.map do |row|
        self.chrome_cookie row
      end
    end
  end

  def self.firefox_cookies
    db_path = Dir.glob("#{Dir.home}/Library/Application Support/Firefox/Profiles/*.default/cookies.sqlite")[0]

    Dir.mktmpdir do |dir|
      FileUtils.copy(db_path, dir)
      db = SQLite3::Database.new db_path
      rows = db.execute 'select * from moz_cookies'
      rows.map do |row|
        self.firefox_cookie row
      end
    end
  end

  def self.chrome_cookie(row)
    creation_utc, host_key, name, value, path, expires_seconds,
      secure, httponly, last_access_utc, has_expires, persistent = row
    self.cookie(name, value, host_key, path, secure, expires_seconds)
  end

  def self.firefox_cookie(row)
    id, base_domain, name, value, host, path, expires_seconds, last_accessed,
      creation_time, secure, http_only = row
    self.cookie(name, value, host, path, secure, expires_seconds)
  end

  def self.cookie(name, value, host, path, secure, expires_seconds)
    c = Mechanize::Cookie.new(name, value)
    c.domain = host
    c.for_domain = host[0] == '.'
    c.path = path
    c.secure = secure == 1
    c.expires = (expires_seconds == 0) ? nil : Time.at(expires_seconds)
    c.version = 0
    c
  end
end

