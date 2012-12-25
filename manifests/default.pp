class { "apt":
  always_apt_update => true,
}

class { 'mysql': }
class { 'mysql::server': }

package { "git":
  require => Class["apt"]
}

package { "apache2":
  require => Class["apt"]
}

package { "mysql":
  require => Class["apt"]
}

exec { "spotweb":
  command => "sudo git clone https://github.com/spotweb/spotweb.git /var/www/spotweb",
  require => Package["git-core"],
}

mysql::db { 'spotweb':
  user     => 'spotwebr',
  password => 'spotweb',
  host     => 'localhost',
  grant    => ['all'],
}

exec { "populate-db":
  command => "cd /var/www/spotweb && /usr/bin/php /var/www/spotweb/upgrade-db.php",
  require => Package["git-core"],
}

file { "/etc/cron.hourly/spotweb_spots":
  owner => "root",
  group => "root",
  mode => 644,
  source => "/vagrant/files/etc/cron.hourly/spotweb_spots"
}