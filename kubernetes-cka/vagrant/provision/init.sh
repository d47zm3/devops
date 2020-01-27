ssh_pub_key="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDDdBBYpkPjpLFyhCv1ZNxNNsVQPNW202hdYJ7+XBpLPA6sbqbp/OXo6hWljxAXcb8EA8SkkFV6yhHn7E1kWn8oNaEFJ4YIzuCDbDkpCMsVLuTar+/px5EXjrl6Y0Oy8hEtoxNJEIyelAtbKWXBsRG6i4qVvz/SkdZmMXR/PcS4gj9xufWJWy5ku/dHcW6+iTeJXpsz265ZkFMf3t8TqiMNUKIGZ/8oWMdz91B7vV/xlYnVOCTEBfSOTLg7QBeWX9sH0Cm5XxABnHSVswTEGSnSGOH67Hw01s5UsWIpu2QO1p+CGmqePUHDXG8H0E9QjV1VFOjFL2lwHiPtITUf8iM3 pub@key"

sudo rm -rf /root/.ssh/
sudo mkdir /root/.ssh
sudo chmod 700 /root/.ssh

echo "${ssh_pub_key}" | sudo tee -a /root/.ssh/authorized_keys
