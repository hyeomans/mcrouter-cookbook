#
# Cookbook Name:: mcrouter
# Recipe:: default
#
# Copyright 2015 EverTrue, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

%w(
  g++
  automake
  autoconf
  autoconf-archive
  libtool
  libboost-all-dev
  libevent-dev
  libdouble-conversion-dev
  libgoogle-glog-dev
  libgflags-dev
  liblz4-dev
  liblzma-dev
  libsnappy-dev
  make
  zlib1g-dev
  binutils-dev
  libjemalloc-dev
  libssl-dev
  libiberty-dev
).each do |pkg|
  package pkg
end

ark 'folly' do
  url 'https://github.com/facebook/folly/archive/v0.47.0.zip'
  path '/opt'
  action :put
end

folly_dir = "#{node['folly']['src_dir']}/folly"

ark 'gtest' do
  url 'http://googletest.googlecode.com/files/gtest-1.7.0.zip'
  path "#{folly_dir}/test"
  action :put
end

execute 'autoreconf_folly' do
  command 'autoreconf -ivf'
  cwd folly_dir
  creates "#{folly_dir}/build-aux"
end

execute 'configure_folly' do
  command './configure'
  cwd folly_dir
end

execute 'make_folly' do
  command 'make'
  cwd folly_dir
end

execute 'check_folly' do
  command 'make check'
  cwd folly_dir
end

execute 'install_folly' do
  command 'make install'
  cwd folly_dir
  creates '/usr/local/lib/libfolly.so'
end
