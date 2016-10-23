# = Class: apache::vhost
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
define apache::vhost (
  $project_name = $title,
  $server_name = 'appserver1604.dev',
  $document_root = '/var/www/appserver1604',
  $project_path = '/vagrant/www/projects'
) {


  # Ensure project_path exists
  if ! defined (File[$project_path]) {
    file { "$project_path":
      # path => $project_path,
      ensure => 'directory',
      recurse => true,
    }
  }


  # create vhost in sites-available
  file { "/etc/apache2/sites-available/$project_name.conf":
    ensure  => file,
    path    => "/etc/apache2/sites-available/$project_name.conf",
    content => template('apache/vhost.conf.erb'),
    require => Package["apache2"],
    subscribe => Package["apache2"],
  }

  # symlink apache site to the site-enabled directory
  file { "/etc/apache2/sites-enabled/$project_name.conf":
    ensure => link,
    target => "/etc/apache2/sites-available/$project_name.conf",
    require => File["/etc/apache2/sites-available/$project_name.conf"],
    # notify => Service["apache2"],
  }

  # symlink apache site to the site-enabled directory
  # if ! defined (File[$document_root]) {
    file { "$document_root":
      ensure  => link,
      # path => "/var/www/$project_name",
      path => $document_root,
      target  => "$project_path/$project_name",
      require => File["/etc/apache2/sites-available/$project_name.conf"],
      # notify => Service["apache2"],
    }
  # }
}
