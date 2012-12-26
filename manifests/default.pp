class { "apt":
  always_apt_update => true,
}

class { 'mysql':
  require => Class['apt']
}

class { 'mysql::server':
  require => Class['apt']
}

package { "git":
  require => Class["apt"]
}

package { "apache2":
  require => Class["apt"]
}

package { "php5":
  require => Class["apt"]
}

package { "php5-mysql":
  require => [Class["apt"], Package["php5"]]
}

exec { "git clone https://github.com/spotweb/spotweb.git":
  alias   => "spotweb",
  cwd     => "/var/www",
  path    => "/usr/bin",
  require => Package['git']
}

mysql::db { 'spotweb':
  user     => 'spotweb',
  password => 'spotweb',
  host     => 'localhost',
  grant    => ['all']
}

exec { "php ./upgrade-db.php":
  alias   => "populate-db",
  cwd     => "/var/www/spotweb",
  path    => "/usr/bin",
  require => [Exec["spotweb"], Database["spotweb"], Package["php5"]]
}

file { "/etc/cron.hourly/spotweb_spots":
  owner => "root",
  group => "root",
  mode => 644,
  source => "/vagrant/files/etc/cron.hourly/spotweb_spots"
}
