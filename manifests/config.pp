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
define apache::config (
  # APACHE2.CONF
  # Timeout 300,
  $timeout = 300,
  # KeepAlive On,
  $keep_alive = 'On',
  # MaxKeepAliveRequests 100,
  $max_keep_alive_requests = 100,
  # KeepAliveTimeout 5,
  $keep_alive_timeout = 5,

  # worker or event
  $mpm_module = 'worker',
  # MPM_.CONF
  # StartServers 2,
  $start_servers = 2,
  # MinSpareThreads 25,
  $min_spare_threads = 25,
  # MaxSpareThreads 75,
  $max_spare_threads = 75,
  # ThreadLimit 64,
  $thread_limit = 64,
  # ThreadsPerChild 25,
  $threads_pre_child = 25,
  # MaxRequestWorkers 150,
  $max_request_workers = 500,
  # MaxConnectionsPerChild 0,
  $max_connections_per_child = 0
) {


  file { '/etc/apache2/apache2.conf':
    ensure    => file,
    path      => '/etc/apache2/apache2.conf',
    content   => template('apache/apache2.conf.erb'),
    require   => Package["apache2"],
    subscribe => Package["apache2"],
  }


  # Disable MPM_PREFORK module
  exec { "a2dismod mpm_prefork":
    path    => "/bin:/usr/bin",
    command => "apt-get update",
    notify => Service['apache2'],
    require => Package['apache2'],
  }

  if $mpm_module == 'worker' {
    # Disable MPM_EVENT module
    exec { "a2dismod mpm_event":
      path    => "/bin:/usr/bin",
      command => "apt-get update",
      notify => Service['apache2'],
      require => Package['apache2'],
    }

    # Enable MPM_WORKER module (faster than prefork + same as event with ssl)
    exec { "a2enmod mpm_worker":
      path    => "/bin:/usr/bin",
      command => "apt-get update",
      notify => Service['apache2'],
      require => Exec['a2dismod mpm_prefork', 'a2dismod mpm_event'],
    }

    file { '/etc/apache2/mods-available/mpm_worker.conf':
      ensure    => file,
      path      => '/etc/apache2/mods-available/mpm_worker.conf',
      content   => template('apache/mpm_worker.conf.erb'),
      require   => Package["apache2"],
      subscribe => Package["apache2"],
    }

  } else {
    # else use mpm_event

    # Disable MPM_EVENT module
    exec { "a2dismod mpm_event":
      path    => "/bin:/usr/bin",
      command => "apt-get update",
      notify => Service['apache2'],
      require => Package['apache2'],
    }

    file { '/etc/apache2/mods-available/mpm_event.conf':
      ensure    => file,
      path      => '/etc/apache2/mods-available/mpm_event.conf',
      content   => template('apache/mpm_event.conf.erb'),
      require   => Package["apache2"],
      subscribe => Package["apache2"],
    }

  }

}
