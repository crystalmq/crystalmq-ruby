require "msgpack"
require "socket"

class CrystalMQ
  class MessagePayload
    attr_reader :message
    
    def initialize(message)
      @message = message
    end
    
    def to_msgpack
      { "message" => @message }.to_msgpack
    end
    
    def self.from_msgpack h
      MessagePayload.new(h["message"])
    end
  end
  
  class Consumer
    
    class ConsumerPayload
      attr_reader :topic, :channel
      def initialize(topic, channel)
        @topic = topic
        @channel = channel
      end
      
      def to_msgpack
        { "topic" => @topic, "channel" => @channel }.to_msgpack
      end
    
      def self.from_msgpack h
        @topic = h["topic"]
        @channel = h["channel"]
      end
    end
        
    def initialize(host, topic, channel)
      @topic = topic
      @channel = channel
      @host = host
      connect_socket
    rescue SocketError
      connect_socket
      retry
    end
    
    def connect_socket
      @socket = TCPSocket.new(@host, 1235)
      @socket.sync = true
    end
    
    def consume
      @socket.write(ConsumerPayload.new(@topic, @channel).to_msgpack)
      to_process = []
      unpacker = MessagePack::Unpacker.new(@socket)
      
      loop do
        message = MessagePayload.from_msgpack(unpacker.read)
        yield message.message
      end
      @socket.close
    rescue SocketError
      connect_socket
      retry
    end
  end
  
  class Producer
    
    class ProducerPayload
      attr_reader  :topic, :message
    
      def initialize(topic, message)
        @topic = topic
        @message = message
      end
    
      def to_msgpack
        { "topic" => @topic, "message" => @message }.to_msgpack
      end
    
      def self.from_msgpack h
        @topic = h["topic"]
        @message = h["message"]
      end
    
    end
    
    def initialize(host, topic)
      @host = host
      @topic = topic
      connect_socket
    rescue SocketError
      connect_socket
      retry
    end
  
    def connect_socket
      @socket = TCPSocket.new(@host, 1234)
      @socket.sync = true
    end
    
    def write(message)
      @socket.write(ProducerPayload.new(@topic, message).to_msgpack)
    rescue SocketError
      connect_socket
      retry
    end
    
    def terminate
      @socket.close
    end
  end
end
