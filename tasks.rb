require 'models/task'

module Tasks
  Task.new 'GitHub', 'http://github.com'

  Task.new 'JIRA', 'http://outrightcom.atlassian.net' do |page|
    page.links.any? { |l| l.uri && l.uri.path =~ /logout/ }
  end

  Task.new 'New Relic', 'http://rpm.newrelic.com'

  Task.new 'Airbrake', 'http://outright.airbrake.io'

  Task.new 'Pager Duty', 'http://outright.pagerduty.com' do |page|
    page.links.any? { |l| l.uri && l.uri.path =~ /sign_out/ }
  end

  Task.new 'Pivotal Tracker', 'http://pivotaltracker.com' do |page|
    page.links.any? { |l| puts l.uri; l.uri && (l.uri.path == '/signin') }
  end
end
