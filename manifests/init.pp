# == Class: apache
#
# Full description of class apache here.
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
# include apache
# apache::config { "apache_config": }
# apache::vhost { $dashboardDomain:
#   server_name   => "$dashboardDomain.dev",
#   document_root => "$wwwFolder/$dashboardDomain",
#   project_path  => $projectsFolder,
# }
#
# === Authors
#
# Matthew Hansen
#
# === Copyright
#
# Copyright 2016 Matthew Hansen
#
class apache {

  # Install apache2 package
  package { 'apache2':
    ensure => installed,
    require => Exec['apt-update']
  }


  # mods
  apache::mods{ 'apache_mods': }

  # delete purge /etc/apache2/sites-enabled/000-default.conf
  # http://docs.puppetlabs.com/references/latest/type.html#tidy.
  tidy { "remove-000-default":
    path    => "/etc/apache2/sites-enabled/000-default.conf",
  }
}
