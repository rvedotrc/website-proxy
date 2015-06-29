Given(/^there is a server on port "([^"]*)"$/) do |port_symbol|
  @backend_server ||= {}
  server = BackendServer.new
  @backend_server[port_symbol] = server
  server.start
end

When(/^the proxy is started with:$/) do |table|
  config = table.rows_hash.entries.map do |k, v|
    [ k, @backend_server[v].port ]
  end.to_h

  image = ENV["IMAGE_ID"] or raise "Need IMAGE_ID env var"
  @proxy = Proxy.new(image, config)
  @proxy.start
end

Then(/^GET requests are mapped as follows:$/) do |table|
  table.hashes.each do |row|
    inurl = "http://#{@proxy.address}#{row["inurl"]}"
    puts "GET #{inurl}"

    backend = @backend_server[row["port"]]
    puts "Expect 'GET #{row["outurl"]}' at #{backend.port}"
  end

end

