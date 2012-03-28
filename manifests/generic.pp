/*
== Definition: postfix::generic

Manages content of the /etc/postfix/generic map.

Parameters:
- *name*: name of address postfix will lookup. See generic(5).
- *destination*: where the emails will be delivered to. See virtual(5).
- *ensure*: present/absent, defaults to present.

Requires:
- Class["postfix"]
- Postfix::Hash["/etc/postfix/generic"]
- Postfix::Config["smtp_generic_maps"]
- common::line (from module common)

Example usage:

  node "toto.example.com" {

    include postfix

    postfix::hash { "/etc/postfix/generic":
      ensure => present,
    }
    postfix::config { "smtp_generic_maps":
      value => "hash:/etc/postfix/generic"
    }
    postfix::generic { "user@example.com":
      ensure      => present,
      destination => "root@example2.com",
    }
  }

*/
define postfix::generic ($ensure="present", $destination) {
  common::line {"${name} ${destination}":
    ensure => $ensure,
    file   => "/etc/postfix/generic",
    line   => "${name} ${destination}",
    notify => Exec["generate /etc/postfix/generic.db"],
    require => Package["postfix"],
  }
}
