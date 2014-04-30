require 'webrick'
require 'json'
require 'debugger'

server = WEBrick::HTTPServer.new(Port: 8080)

server.mount_proc('/') do |req, res|
  res.body = <<-HEREDOC
  Body: #{req.body}
  Header: #{req.header}
  request_line: #{req.request_line}
  request_method: #{req.request_method}
  http_version: #{req.http_version}
  unpqrsed_uri: #{req.unparsed_uri}
    HEREDOC
  ['request_method', 'path', 'request_uri'].each do |attr|
    res.body << "#{attr}: #{req.send(attr)}\n"
  end
end

trap('INT') { server.shutdown }

server.start