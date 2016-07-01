require "serverspec"
require "docker"

describe "Dockerfile" do
  before(:all) do
    if ENV['IMAGEID']
      image = Docker::Image.get(ENV['IMAGEID'])
    else
      image = Docker::Image.build_from_dir('.')
    end

    set :os, family: :debian
    set :backend, :docker
    set :docker_image, image.id
  end

  describe package('nginx') do
    it { should be_installed }
  end

  describe package('php5-fpm') do
    it { should be_installed }
  end

  describe package('supervisor') do
    it { should be_installed }
  end
  
  describe package('graphicsmagick') do
    it { should be_installed }
  end

  describe package('postfix') do
    it { should be_installed }
  end

  describe service('nginx') do
    it "nginx should be running under supervisor" do
      wait_retry 30 do
        should be_running.under('supervisor')
      end
    end
  end

  describe port(80) do
    it "nginx should be listening" do
      wait_retry 30 do
        should be_listening
      end
    end
  end

  describe service('php-fpm') do
    it "php-fpm should be running under supervisor" do
      wait_retry 30 do
        should be_running.under('supervisor')
      end
    end
  end

  describe file('/var/run/php5-fpm.sock') do
    it { should be_socket }
  end

  describe file('/bin/composer') do
    it { should be_file }
  end

end

def wait_retry(time, increment = 1, elapsed_time = 0, &block)
  begin
    yield
  rescue Exception => e
    if elapsed_time >= time
      raise e
    else
      sleep increment
      wait_retry(time, increment, elapsed_time + increment, &block)
    end
  end
end
