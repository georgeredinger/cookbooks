#
# Cookbook Name:: dotfiles
# Recipe:: default
#
# Copyright 2011, Aaron Bull Schaefer
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#

include_recipe 'git'
include_recipe 'zsh'

node.set_unless['dotfiles']['enable_submodules'] = false
node.set_unless['dotfiles']['shell'] = '/bin/zsh'

git 'dotfiles' do
  destination '/home/vagrant/.dotfiles'
  repository node['dotfiles']['repository']
  reference 'master'
  action :sync
  user 'vagrant'
  group 'vagrant'
  enable_submodules node['dotfiles']['enable_submodules']
end

user 'vagrant' do
  action :modify
  shell node['dotfiles']['shell']
end

execute 'install-links' do
  command '/home/vagrant/.dotfiles/install-links.sh'
  user 'vagrant'
  group 'vagrant'
  environment ({'HOME' => '/home/vagrant'})
  action :nothing
  subscribes :run, resources(:git => 'dotfiles')
  only_if { File.exists?('/home/vagrant/.dotfiles/install-links.sh') }
end
