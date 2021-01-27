# -*- mode: ruby -*-
# vi: set ft=ruby :


Vagrant.configure("2") do |config|
  config.vagrant.plugins = ["vagrant-disksize", "vagrant-vbguest"]
  config.disksize.size = "50GB"
  config.vm.box = "ubuntu/bionic64"
  config.vm.hostname = "klee"
  config.vm.define "klee"
  config.vm.network "forwarded_port", guest: 8888, host:9999

  config.vm.provider "virtualbox" do |vb|
    vb.name = "klee"
    vb.memory = "16384"
    vb.cpus = "6"
    vb.customize ["modifyvm", :id, "--ioapic", "on"]
  end
  
  config.vm.provision "bootstrap", type: "shell",
      privileged: true, run: "always" do |bs|
    bs.path = "bootstrap.sh"
  end
  
  config.vm.provision "klee_deps", type: "shell",
      privileged: false, run: "never" do |kd|
    kd.path = "install_deps.sh"
  end
  
  config.vm.provision "klee", type: "shell",
      privileged: false, run: "never" do |k|
    k.path = "install_klee.sh"
  end

end
