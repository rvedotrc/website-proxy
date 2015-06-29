require 'webrick'
require 'json'

class BackendServer

  attr_reader :server

  def initialize
    @server = WEBrick::HTTPServer.new :Port => 0
    @server.mount_proc '/' do |req, res|
      data = {
        req: req,
      }
      res.body = JSON.generate(data)
    end
  end

  def start
    @thread = Thread.new do
      @server.start
    end
  end

  def port
    # Can't find documentation for this
    @server.config[:Port]
  end

end
