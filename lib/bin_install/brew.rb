require 'bin_install/brew/cask'

module BinInstall
  module Brew
    def self.require!
      if installed?
        update!
      else
        abort('Homebrew is required! Visit https://brew.sh/ to install.'.red)
      end
    end

    def self.update
      puts 'Updating Homebrew...'.white
      system('brew update')
      Cask.tap
    end

    def self.update!
      puts 'Updating Homebrew...'.white
      BinInstall.system!('brew update')
      Cask.tap!
    end

    def self.install_package(package)
      system("brew install #{package}")
    end

    def self.install_package!(package)
      BinInstall.system!("brew install #{package}")
    end

    def self.upgrade_package(package)
      if package_latest_version?(package)
        puts "#{package} is already the latest version. Skipping.".blue
      else
        system("brew upgrade #{package}")
      end
    end

    def self.upgrade_package!(package)
      if package_latest_version?(package)
        puts "#{package} is already the latest version. Skipping.".blue
      else
        BinInstall.system!("brew upgrade #{package}")
      end
    end

    def self.install_or_upgrade(package)
      if package_installed?(package)
        upgrade_package(package)
      else
        install_package(package)
      end
    end

    def self.install_or_upgrade!(package)
      if package_installed?(package)
        upgrade_package!(package)
      else
        install_package!(package)
      end
    end

    def self.installed?
      system('brew --version')
    end

    def self.package_installed?(package)
      system("brew list --versions #{package}")
    end

    def self.package_latest_version?(package)
      system("brew outdated #{package}")
    end
  end
end
