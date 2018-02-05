gerrit
======

This is a fork of [kbrebanov/ansible-gerrit/](https://github.com/kbrebanov/ansible-gerrit/)
for Centos 7.

Requirements
------------

This role requires Ansible 1.4 or higher.

Role Variables
--------------

| Name                                   | Default                                                          | Description                                                                                                               |
|----------------------------------------|------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------|
| gerrit_version                         | 2.11.5                                                           | Gerrit version to install                                                                                                 |
| gerrit_sha256sum                       | 2b252f2e2c65c4fe20eaac8f060f8fce89579d3fcdfb07b369e669578b77eeda | SHA 256 sum of Gerrit version                                                                                             |
| gerrit_download_server                 | 'https://gerrit-releases.storage.googleapis.com'                 | Server to download the Gerrit war file from                                                                               |
| gerrit_install_plugins                 | []                                                               | List of core plugins to install during initialization                                                                     |
| gerrit_auth_type                       | 'OPENID'                                                         | Type of user authentication                                                                                               |
| gerrit_auth_register_email_private_key | Not set. Gerrit will generate a random key during site init.     | Private key to use for token verification when adding a new email address                                                 |
| gerrit_canonical_web_url               | 'http://localhost:8080/'                                         | The default URL for Gerrit                                                                                                |
| gerrit_container_java_home             | /usr/lib/jvm/java-8-openjdk-amd64/jre                            | Java home location                                                                                                        |
| gerrit_database_type                   | 'h2'                                                             | Type of database server                                                                                                   |
| gerrit_database_db                     | 'db/ReviewDB'                                                    | Database path (h2) or name (PostgreSQL, MySQL)                                                                            |
| gerrit_database_username               | ''                                                               | Username to connect to the database server as                                                                             |
| gerrit_database_password               | ''                                                               | Password to authenticate to the database server with                                                                      |
| gerrit_database_hostname               | 'localhost'                                                      | Hostname of the database server                                                                                           |
| gerrit_httpd_listen_url                | 'http://*:8080/'                                                 | The URL the internal HTTP daemon should listen on                                                                         |
| gerrit_sendemail_smtp_server           | 'localhost'                                                      | Hostname (or IP address) of a SMTP server that will relay messages                                                        |
| gerrit_sshd_listen_address             | '*:29418'                                                        | The local addresses the internal SSHD daemon should listen on                                                             |
| gerrit_ldap_server                     | 'ldap://ldap.example.com'                                        | URL of the LDAP server to query for user information and group membership                                                 |
| gerrit_ldap_username                   | Not set                                                          | Username to authenticate to the LDAP server                                                                               |
| gerrit_ldap_password                   | Not set                                                          | Password to authenticate to the LDAP server                                                                               |
| gerrit_ldap_account_base               | ou=people,dc=example,dc=com                                      | Root of the tree containing all user accounts                                                                             |
| gerrit_ldap_account_scope              | subtree                                                          | Scope of the search performed for accounts (one, sub or subtree, base or object)                                          |
| gerrit_ldap_account_pattern            | (uid=${username})                                                | Query pattern to use when searching for a user account                                                                    |
| gerrit_ldap_account_full_name          | displayName                                                      | Name of an attribute on the user account object which contains the initial value for the user's full name field in Gerrit |
| gerrit_ldap_account_email_address      | mail                                                             | Name of an attribute on the user account object which contains the user's Internet email address                          |
| gerrit_ldap_account_ssh_username       | Not set                                                          | Name of an attribute on the user account object which contains the initial value for the user's ssh username in Gerrit    |
| gerrit_ldap_group_base                 | ou=groups,dc=example,dc=com                                      | Root of the tree containing all group objects                                                                             |
| gerrit_ldap_group_scope                | subtree                                                          | Scope of the search performed for group objects (one, sub or subtree, base or object)                                     |
| gerrit_ldap_group_pattern              | (cn=${groupname})                                                | Query pattern used when searching for an LDAP group to connect to a Gerrit group                                          |
| gerrit_ldap_group_member_pattern       | (|(memberUid=${username})(gidNumber=${gidNumber}))               | Query pattern to use when searching for the groups that a user account is currently a member of                           |
| gerrit_ldap_group_name                 | cn                                                               | Name of the attribute on the group object which contains the value to use as the group name in Gerrit                     |
| gerrit_plugins_allow_remote_admin      | false                                                            | Allow remote admin of plugins                                                                                             |

Example Playbook
----------------

Install Gerrit
```
- hosts: all
  roles:
    - { role: kbrebanov.gerrit }
```

Install Gerrit specifying version
```
- hosts: all
  roles:
    - { role: kbrebanov.gerrit, gerrit_version: 2.9.3, gerrit_sha256sum: fad71b288ecaf3241ea11fecebb2d5be4cfbdfade3e2037d23b94cce3dd3bc48 }
```

Install Gerrit downloading .war file from Maven Central
```
- hosts: all
  roles:
    - { role: kbrebanov.gerrit, gerrit_version: 2.9.3, gerrit_sha256sum: fad71b288ecaf3241ea11fecebb2d5be4cfbdfade3e2037d23b94cce3dd3bc48,
        gerrit_download_maven: true, gerrit_download_server: http://repo1.maven.org/maven2 }
```

License
-------

BSD

Author Information
------------------

Kevin Brebanov and Nigel Babu
