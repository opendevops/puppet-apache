# = Class: apache::mods
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#   include apache
#   apache::vhost{ 'appserver1604':
#     projectPath => '/vagrant/www/projects'
#   }
#
# === Authors
#
# Matthew Hansen
#
# === Copyright
#
# Copyright 2016 Matthew Hansen
#
define apache::mods (
  $enable_rewrite = true,
  $enable_headers = true,
  $enable_alias = true,
  $enable_actions = true,
  $enable_fastcgi = true,
  $enable_proxy = true,
) {


  # starts the apache2 service once the packages installed, and monitors changes to its configuration files and reloads if nesessary
  service { 'apache2':
    ensure    => running,
    enable    => true,
    require   => Package['apache2'],
  }

  if $enable_rewrite {
    exec { "a2enmod rewrite":
      path       => "/usr/bin:/usr/sbin:/bin",
      alias      => 'enable-mod-rewrite',
      creates    => '/etc/apache2/mods-enabled/rewrite.load',
      notify     => Service['apache2'],
      require    => Package['apache2'],
    }
  }

  if $enable_headers {
    exec { "a2enmod headers":
      path       => "/usr/bin:/usr/sbin:/bin",
      alias      => 'enable-mod-headers',
      creates    => '/etc/apache2/mods-enabled/headers.load',
      notify     => Service['apache2'],
      require    => Package['apache2'],
    }
  }

  if $enable_alias {
    exec { "a2enmod alias":
      path       => "/usr/bin:/usr/sbin:/bin",
      alias      => 'enable-mod-alias',
      creates    => '/etc/apache2/mods-enabled/alias.load',
      notify     => Service['apache2'],
      require    => Package['apache2'],
    }

  }

  if $enable_actions {
    exec { "a2enmod actions":
      path       => "/usr/bin:/usr/sbin:/bin",
      alias      => 'enable-mod-actions',
      creates    => '/etc/apache2/mods-enabled/actions.load',
      notify     => Service['apache2'],
      require    => Package['apache2'],
    }
  }


  if $enable_fastcgi {
    package { 'libapache2-mod-fastcgi':
      ensure     => installed,
      require    => Package['apache2'],
    }

    exec { "a2enmod fastcgi":
      path       => "/usr/bin:/usr/sbin:/bin",
      alias      => 'enable-mod-fastcgi',
      creates    => '/etc/apache2/mods-enabled/fastcgi.load',
      notify     => Service['apache2'],
      require    => Package['libapache2-mod-fastcgi'],
    }
  }


  if $enable_proxy {
    exec { "a2enmod proxy":
      path       => "/usr/bin:/usr/sbin:/bin",
      alias      => 'enable-mod-proxy',
      creates    => '/etc/apache2/mods-enabled/proxy.load',
      notify     => Service['apache2'],
      require    => Package['apache2'],
    }

    exec { "a2enmod proxy_http":
      path       => "/usr/bin:/usr/sbin:/bin",
      alias      => 'enable-mod-proxy_http',
      creates    => '/etc/apache2/mods-enabled/proxy_http.load',
      notify     => Service['apache2'],
      require    => Exec['a2enmod proxy'],
    }

    exec { "a2enmod proxy_fcgi":
      path       => "/usr/bin:/usr/sbin:/bin",
      alias      => 'enable-mod-proxy_fcgi',
      creates    => '/etc/apache2/mods-enabled/proxy_fcgi.load',
      notify     => Service['apache2'],
      require    => Exec['a2enmod proxy'],
    }
  }

}
