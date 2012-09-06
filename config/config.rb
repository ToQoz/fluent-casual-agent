FluentCasualAgent.configure do |config|
  config.host = '0.0.0.0'         # host for fluentd
  config.port = '24224'           # port for fluentd
  config.targets = [              # target info list for logging
    {
      path: "/var/log/nginx.log", # filepath for tail -f
      tag: "nginx"                # tag for fluentd
    }, 
    { path: "/var/log/mongodb.log", tag: "mongo" }
  ]
  config.observer do |o|
    o.interval = 180 # 180 second
  end
  config.notifications do |n|
    n.irc do |i|
      i.host = "0.0.0.0"
      i.port = "6667"
      i.channel = "#channel"
      i.nick = "fluent-causal-agent"
      i.password = "password"
      i.message = "fluentd is dead"
    end
  end
end
