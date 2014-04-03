#!/usr/bin/ruby

=begin
Author: Alex Talker, 1.04.2014
License: zlib
Review: Simple managing build packages for Arch Linux packaging system(Don't need in ALPM).
Written for catalog, maked with help 'yaourt -G <package name>'
<here i didn't make tree, cause having sleep....>
Happy 1 April!
=end

class Package
  
  MAKEPKG = '/usr/bin/makepkg'
  PACMAN = '/usr/bin/pacman'
  LOG_BUILD = 'manager-build.log'
  LOG_INSTALL = 'manager-install.log'
  
  def initialize(file='PKGBUILD')
    raise ArgumentErorr, "Package: argument must respond to to_s" unless file.respond_to? :to_s
    @file = file.to_s
  end
  
  def build
    system(MAKEPKG, '-s', '-p',@file, '--noconfirm', '-L', LOG_BUILD)
  end
  
  def install
    system(MAKEPKG, '-i', '--noconfirm', '-L', LOG_INSTALL, '--skipchecksums')
  end
  
end
module Packages
  def self.cd path
    Dir.chdir path
  rescue => e
    puts "Couldn't cd to path #{path}:#{e.message}"
  end

  def self.each packages
    packages.each do |package|
      if cd package
	p = Package.new
	yield p,package
	cd '..'
      end
    end
  end
end

key, *packages = ARGV.clone

HELP = <<TEXT
build <packages> -- build packages in directories at it with name like name package
install <packages> -- build packages in directories at it with name like name package
help -- get this help
TEXT

case key
when 'help'
  puts Help
when 'build'
  Packages.each(packages) do |p,name|
    puts "Build Error in package #{name}" unless p.build
  end
when 'install'
  Packages.each(packages) do |p,name|
    puts "Install Error in package #{name}" unless p.install
  end
else
  puts "Unsuppported key, write 'manager help' for get help!"
end
# ARGV.each { |package|
#   if cd(package)
#     system('pwd')
#     cd('..')
#   end
#   }