# example

FluentCasualAgent.configure do |config|
  config.host = '0.0.0.0'         # host for fluentd
  config.port = '24224'           # port for fluentd
  config.targets = [              # target info list for logging
    {
      path: "/var/log/nginx.log", # filepath for tail -f
      tag: "nginx"                # tag for fluentd
    }, 
    {
      path: "/var/log/mongodb.log",
      tag: "mongo"
    }
  ]
end
