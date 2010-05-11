create table category(
    category_id int(10) unsigned NOT NULL auto_increment,
    category_key varchar(255) NOT NULL,
    category_name varchar(255) NOT NULL,
    sort int(10) unsigned NOT NULL,
    remote_user varchar(255) NOT NULL, 
    created_at datetime NOT NULL default '0000-00-00 00:00:00',
    updated_at timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
    PRIMARY KEY (category_id),
    UNIQUE KEY(category_key)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

create table category_body (
    category_id int(10) unsigned NOT NULL ,
    remote_user varchar(255) NOT NULL,
    version int(10) unsigned NOT NULL ,
    body TEXT NOT NULL,
    created_at datetime NOT NULL default '0000-00-00 00:00:00',
    updated_at timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
    PRIMARY KEY (category_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

create table category_body_history (
    category_body_history_id int(10) unsigned NOT NULL auto_increment,
    category_id int(10) unsigned NOT NULL ,
    version int(10) unsigned NOT NULL ,
    remote_user varchar(255) NOT NULL,
    compressed_body BLOB NOT NULL,
    created_at datetime NOT NULL default '0000-00-00 00:00:00',
    updated_at timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
    PRIMARY KEY (category_body_history_id),
    UNIQUE KEY(category_id,version)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

create table article( 
    article_id int(10) unsigned NOT NULL auto_increment,
    category_id int unsigned NOT NULL,
    article_name  varchar(255) NOT NULL,
    on_blog tinyint unsigned NOT NULL,
    bloged_at datetime NOT NULL default '0000-00-00 00:00:00',
    remote_user varchar(255) NOT NULL, 
    created_at datetime NOT NULL default '0000-00-00 00:00:00',
    updated_at timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
    PRIMARY KEY (article_id),
    UNIQUE KEY(category_id,article_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

create table article_body ( 
    article_id int(10) unsigned NOT NULL ,
    remote_user varchar(255) NOT NULL,
    body TEXT NOT NULL,
    version int(10) unsigned NOT NULL ,
    created_at datetime NOT NULL default '0000-00-00 00:00:00',
    updated_at timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
    PRIMARY KEY (article_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

create table article_body_history (
    article_body_history_id int(10) unsigned NOT NULL auto_increment,
    article_id int(10) unsigned NOT NULL ,
    version int(10) unsigned NOT NULL ,
    remote_user varchar(255) NOT NULL,
    compressed_body BLOB NOT NULL,
    created_at datetime NOT NULL default '0000-00-00 00:00:00',
    updated_at timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
    PRIMARY KEY (article_body_history_id),
    UNIQUE KEY(article_id,version)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


create table tag (
    tag_id int(10) unsigned NOT NULL auto_increment,
    tag_name  varchar(255) NOT NULL,
    created_at datetime NOT NULL default '0000-00-00 00:00:00',
    updated_at timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
    PRIMARY KEY (tag_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

create table article_tag (
    id int(10) unsigned NOT NULL auto_increment,
    article_id int(10) unsigned NOT NULL,
    tag_id int(10) unsigned NOT NULL,
    created_at datetime NOT NULL default '0000-00-00 00:00:00',
    updated_at timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY(article_id,tag_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

create table sidebar (
    sidebar_id int(10) unsigned NOT NULL auto_increment,
    category_id int(10) unsigned NOT NULL,
    sidebar_plugin varchar(255) NOT NULL,
    sort int(10) unsigned NOT NULL,
    pson TEXT NOT NULL,
    created_at datetime NOT NULL default '0000-00-00 00:00:00',
    updated_at timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
    PRIMARY KEY (sidebar_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

