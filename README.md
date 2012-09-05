## Usage

```sh
# use ruby1.9.3
$ bundle install --path=vendor/bundles
$ bundle exec bin/fluent-casual-agent -t #{target_file_path} -h #{host} -p #{port}
```

## Configuration

### example

```ruby
# config.rb
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
```
