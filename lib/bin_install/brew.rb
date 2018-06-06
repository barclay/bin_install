require 'bin_install/brew/cask'

module BinInstall
  module Brew
    def self.require!
      puts 'd1'
      system 'source /Users/david/.zshrc'

            puts 'moo'
            puts `echo $SHELL`
            puts 'foo'
            puts `echo $0`

            puts 'now system'
            system 'echo $SHELL'
            system 'echo $0'
            puts 'done'

            system `zsh -c "echo $0"`
            system `zsh -c "echo $SHELL"`

      puts 'd2'
      abort('stop')
      if installed?
        update!
      else
        puts 'Homebrew is required.'.red
        puts 'Visit https://brew.sh/ for more information.'
        ask!
        abort('Can not continue without Homebrew.'.red) unless installed?
      end
    end

    def self.install
      puts 'Installing Homebrew...'.white
      system('/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"')
    end

    def self.install!
      puts 'Installing Homebrew...'.white
      BinInstall.system!('/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"')
    end

    def self.ask
      return if installed?

      print 'Would you like to install Homebrew? [Y/n]: '
      install if Shell.default_yes?(gets.chomp)
    end

    def self.ask!
      print 'Would you like to install Homebrew? [Y/n]: '
      install! if Shell.default_yes?(gets.chomp)
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
      Shell.executable_exists?('brew')
    end

    def self.package_installed?(package)
      system("brew list --versions #{package}")
    end

    def self.package_latest_version?(package)
      system("brew outdated #{package}")
    end
  end
end
