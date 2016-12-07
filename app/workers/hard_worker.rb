class HardWorker
  include Sidekiq::Worker
  def perform(name)
    File.open('/home/darkness/insilico/log.txt', 'w') { |f| f << name }
  end
end