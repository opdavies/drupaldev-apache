class drupal_site ($site_name) {
  file { 'site-root':
    path   => "/var/www/${site_name}",
    ensure => directory,
  }

  if (defined(Class["mysql::server"])) {
    mysql_database { 'default-db':
      require => Class['mysql::server'],
      name    => $site_name,
      ensure  => present,
    }

    mysql_user { 'default-dbuser@localhost':
      require       => Class['mysql::server'],
      name          => "${site_name}@localhost",
      password_hash => mysql_password($site_name)
    }

    mysql_grant { "${site_name}@localhost/${site_name}.*":
      require    => Class['mysql::server'],
      user       => "${site_name}@localhost",
      table      => "${site_name}.*",
      privileges => ["ALL"],
      ensure     => "present"
    }
  }
}