#!/bin/bash
echo 'Start provision script'
sudo echo "vagrant ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/vagrant
echo 'Add repo ansible for latest ver'
apt install -y software-properties-common
apt-add-repository ppa:ansible/ansible
echo 'Update package'
apt update
echo 'Install ansible'
apt install -y ansible
echo 'Configure ansible hosts'
echo -e "[local]\nlocalhost ansible_connection=local\n\n[all:vars]\nansible_python_interpreter=/usr/bin/python3\n" | sudo tee --append /etc/ansible/hosts > /dev/null
echo 'Activation playbook - package'
ansible-playbook ./ansible-temp/playbook-pkg.yml
echo 'Activation playbook - node exporter'
ansible-playbook ./ansible-temp/node-exporter-playbook.yml
echo 'Activation playbook - docker'
ansible-playbook ./ansible-temp/docker-playbook.yml
echo 'docker-compose up prometheus & grafana'
docker-compose -f /home/vagrant/docker-temp/docker-compose.yml up -d
exit 0