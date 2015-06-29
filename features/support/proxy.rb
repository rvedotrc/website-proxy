class Proxy

  attr_reader :config, :cid

  def initialize(image, config)
    @image = image
    @config = config
  end

  def start
    puts "Starting container for image #{@images.inspect} with config #{@config.inspect}"
    env = @config.entries.map {|k,v| [ "--env", "#{k}=#{v}" ]}.flatten

    out_r, out_w = IO.pipe

    pid = spawn(
      "docker", "run", "-id", *env, @image, "sh",
      out: out_w,
    )

    @cid = out_r.gets.chomp

    Process.wait pid
    $?.success? or raise

    at_exit { stop }
    puts "Started container #{cid}"
  end

  def stop
    puts "Stopping container #{cid}"
    system "docker rm --force #{cid}"
  end

  def address
    inspect[0]["NetworkSettings"]["IPAddress"]
  end

  def inspect
    @inspect ||= JSON.parse(`docker inspect #{cid}`)
  end

end
