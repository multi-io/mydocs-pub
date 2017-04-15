# Inventory

Inventory file name defaults to /etc/ansible/hosts. Cmdline options -i
\<file\>


## Hosts and Groups:


```
mail.example.com

[webservers]
foo.example.com
bar.example.com

[dbservers]
one.example.com
two.example.com
```

groups of groups:

```
[atlanta]
host1
host2

[raleigh]
host2
host3

[southeast:children]
atlanta
raleigh
```

special group "all" contains all hosts.


## Host and Group Variables:

(TODO verify) variables in general: one namespace for variables;
variables may be set basically anywhere, i.e. at the host/inventory,
play or task level (see below), and used in task invocations and
templates (see below).

Setting at the host/inventory level ("host variables"):

- directly in inventory file

```
myhost.foo.com var1=foo var2=bar ...

[mygroup:vars]
var3=x
var4=y
```

- or in separate variables yml files (suffix .yml is optional)

```
host_vars/<hostname>.yml
host_vars/<hostname>/<anything>.yml
group_vars/<groupname>.yml
group_vars/<groupname>/<anything>.yml
```

Some variables influence ansible's built-in operations on the host(s):

ansible_user, ansible_port, ansible_ssh_private_key_file, ...


## Variables Preference

Least to most preferred:

- role defaults [1]

- inventory vars [2]

- inventory group_vars

- inventory host_vars

- playbook group_vars

- playbook host_vars

- host facts

- play vars

- play vars_prompt

- play vars_files

- registered vars

- set_facts

- role and include vars

- block vars (only for tasks in block)

- task vars (only for the task)

- extra vars (always win precedence)


## Dynamic Inventories:

You can write scripts that provide the inventory data (including vars
and all) dynamically. Existing scripts for Cobbler, AWS, OpenStack,
...



# Command Line

"ansible" for ad-hoc invocation of Ansible modules against inventory
hosts, "ansible-playbook" for running Ansible playbooks (ordered
collections of ansible module invocations).

`ansible [-i <inventory file>] [other options] <hosts pattern> -m <module_name> -a <arguments>`

\<hosts pattern\> is a host or group name, or multiple of those,
connected with a :. Globbing with * or [startnum:endnum] allowed,
e.g. 192.168.1.*, webservers:app[1:10]

\<module_name\> defaults to "command", which takes the command line to
run as its only argument.

Example: `ansible all -a "/sbin/shutdown -h now"`

Besides sshd, Ansible only requires Python on the managed host. Some
modules like "command" don't even need that -- so you can use
"command" to install Python, then go on using other modules. Every
Ansible invocation on a host uploads all required modules to a
temporary directory on the host, runs them, then cleans up.


## Common Other Commandline Options, Privilege Escalation:

Use ssh password auth (rather than PKI): `--ask-pass (-k)`

Run as another user, possibly using sudo: `-u username
[--become|-b [--ask-become-pass]]`.

There is a corresponding set of directives, settable at the play or
task level:

```
- name: Run a command as the apache user
  command: somecommand
  become: true
  become_user: apache
```

There are also a corresponding variables (which, when set, will
override the directive). Normally defined in the inventory.

Number of parallel runs (when running on multiple hosts): `-f 10`


## Examples, Common Modules:

"shell" module instead of "command" for running a shell command with
pipes/redirects etc.

file copy: `ansible atlanta -m copy -a "src=/etc/hosts dest=/tmp/hosts"`

file copy, expanding a template: `ansible timeservers -m template -a "src=ntp.conf.j2 dest=/etc/ntp.conf"`

file owner/mode change: `ansible webservers -m file -a "dest=/srv/foo/b.txt mode=600 owner=mdehaan group=mdehaan"`

package mgmt: `ansible webservers -m yum -a "name=ruby state=present"`

create user/group: `ansible all -m user -a "name=foo password=<crypted password here>"`

git clone: `ansible webservers -m git -a "repo=git://foo.example.org/repo.git dest=/srv/myapp version=HEAD"`

service mgmt (login user ubuntu, with `-b` (become) for sudoing): `ansible webservers -u ubuntu -b -m service -a "name=httpd state=started"`



# Modules

- Named

- take parameters

- return a return value (normally a map, can be put into a variable
  ("registered", see "variables" below) and processed further from
  there)
  
- return success state (invocation successful or not)

- return "changed" flag (did the invocation change anything in the
  system or not)

- Ansible provides some template filters to extract these pieces of
  information. Examples:
  
```
tasks:

  - shell: /usr/bin/foo
    register: result
    ignore_errors: True

  - debug: msg="it failed"
    when: result|failed

  # in most cases you'll want a handler, but if you want to do something right now, this is nice
  - debug: msg="it changed"
    when: result|changed

  - debug: msg="it succeeded in Ansible >= 2.1"
    when: result|succeeded

  - debug: msg="it succeeded"
    when: result|success

  - debug: msg="it was skipped"
    when: result|skipped
```
  

# Playbooks

playbook 1---* play 1---* task 1--1 module invocation


sample:

```
---
- hosts: webservers
  vars:
    http_port: 80
    max_clients: 200
  remote_user: root
  tasks:
  - name: ensure apache is at the latest version
    yum: name=httpd state=latest
  - name: write the apache config file
    template: src=/srv/httpd.j2 dest=/etc/httpd.conf
    notify:
    - restart apache
  - name: ensure apache is running (and enable it at boot)
    service: name=httpd state=started enabled=yes
  handlers:
    - name: restart apache
      service: name=httpd state=restarted

- hosts: databases
  remote_user: root

  tasks:
  - name: ensure postgresql is at the latest version
    yum: name=postgresql state=latest
  - name: ensure that postgresql is started
    service: name=postgresql state=started
```

Task arguments can also be specified as yml maps.

Remote user, sudo method etc. can be specified per play or per task.


The whole thing is run top to bottom.

Hosts with failed tasks are taken out of the rotation for the entire
playbook. Tasks should be idempotent, so you can just correct mistakes
and run again.

Variable references: {{ .. }}

E.g.

```
tasks:
  - name: create a virtual host file for {{ vhost }}
    template: src=somefile.j2 dest=/etc/httpd/conf.d/{{ vhost }}
```


## Handlers

Each task (module invocation) tells Ansible whether it has made
changes to the system or not. It can declare a "notify" clause to
invoke a *handler* when it did change the system.

Handler invocations are usually coalesced by Ansible, i.e. they'll be
invoked at most once per host, regardless of how many tasks notify
them. You can force this explicitly though via `module meta:
flush_handlers`.

Handler flushing is done implicitly an the end of `pre_tasks`,
`tasks`, `post_tasks` sections (see below).

```
- name: template configuration file
  template: src=template.j2 dest=/etc/foo.conf
  notify:
     - restart memcached
     - restart apache
  ...
  handlers:
    - name: restart memcached
      service: name=memcached state=restarted
    - name: restart apache
      service: name=httpd state=restarted

```

(2.2) Tasks can also notify and handlers can listen to "topics"
rather than specific handlers.


## Task Include Files

Files containing a flat list of tasks, included via `include:`
whereever tasks are expected (tasks section, handlers section).

```
tasks:
  - include: tasks/foo.yml
  - include: tasks/wordpress.yml wp_user=timmy
```

## Playbook Includes

Playbooks can include other playbooks using an `include:` statement at
the top level.


## Roles

Are task include files, with built-in search paths for tasks and vars.

References in plays like this:

```
- hosts: webservers
  roles:
     - common
     - webservers
```

Roles defined in directories like this:

```
site.yml
webservers.yml
fooservers.yml
roles/
   common/
     files/
     templates/
     tasks/
     handlers/
     vars/
     defaults/
     meta/
   webservers/
     files/
     templates/
     tasks/
     handlers/
     vars/
     defaults/
     meta/
```

- Tasks read from `roles/<role>/tasks/main.yml` (flat list of tasks)

- handlers read from `roles/<role>/handlers/main.yml`

- variables read from `roles/<role>/vars/main.yml`

- default variables read from `roles/<role>/defaults/main.yml`

Tasks with module type `copy`, `script`, `template`, `include` can
reference files in `roles/<role>/{files,templates,tasks}/` without
path prefixes.

More features:

```
- hosts: somehosts
  roles:
     ## normal
     - common
     ## parameterized
     - { role: foo_app_instance, dir: '/opt/a',  app_port: 5000 }
     ## conditional application
     - { role: some_role, when: "ansible_os_family == 'RedHat'" }
     ## set tags on all tasks of the role while running it (see below
     ## for tags)
     - { role: foo, tags: ["bar", "baz"] }
```

## Role dependencies

- dependencies on other roles read from `roles/<role>/meta/main.yml`. Sample:

```
---
# allow_duplicates: yes  # to have the same role instantiated multiple
                         #  times if it is depended upon multiple times 
dependencies:
  - { role: common, some_parameter: 3 }
  - { role: apache, apache_port: 80 }
  - { role: postgres, dbname: blarg, other_parameter: 12 }
  - { role: '/path/to/common/roles/foo', x: 1 }
```

- custom Ansible modules to be distributed with a role go into
  `roles/<role>/library/`

    - this can be used primarily for distributing internal modules for
      an organization; it can also be used to provide patchsets agaist
      core modules.
    
    - generally, it is preferable to write custom modules independently
      of any roles, and maybe submit them to Ansible for inclusion in
      the core distribution

### include_role

New in Ansible 2.2, there's also the `include_role` module for
defining a task that runs a role:

```
- include_role:
    name: apache
```

With parameter passing:

```
- name: Install Postgres
  include_role:
    name: postgres 
  vars:
    dbname: blarg
    other_parameter: 12
```


```
22:56 < multi_io> do role dependencies in meta/main.yml have any use at all now that we have the include_role module?
22:57 < agaffney> they have less use, but include_role is still a bit...glitchy
22:57 < multi_io> agaffney: how so?
22:58 < agaffney> the was weirdness in 2.2.x in certain corner cases, and I don't know if it has all been discovered/fixed in 2.3
22:58 < agaffney> but include_role was only a "preview" feature in 2.2
```


# Tags

A task may have zero or more tags (which are just strings) added to
it. When running a playbook, you can specify to only run tasks having
or not having specific tags.

## Adding Tags to Tasks

Directly at the task definition:

```
---
# file: roles/common/tasks/main.yml

- name: be sure ntp is installed
  yum: name=ntp state=installed
  tags: ntp
```

```
tasks:

    - yum: name={{ item }} state=installed
      with_items:
         - httpd
         - memcached
      tags:
         - packages

    - template: src=templates/src.j2 dest=/etc/foo.conf
      tags:
         - configuration
```

When running a role:

```
- hosts: somehosts
  roles:
     ## set tags on all tasks of the role while running it
     - { role: foo, tags: ["bar", "baz"] }
```

## Specifying Tags When Running Playbooks

*Only* possible on the command line.

```
ansible-playbook example.yml --tags "configuration,packages"

ansible-playbook example.yml --skip-tags "notification"
```


## "always" Tag

The special tag "always" will always run a task, unless specifically
skipped (`--skip-tags always`).



# Variables

(refresh from above)

One namespace per host for variables; variables may be set basically
anywhere, i.e. at the host/inventory, play or task level, and
referenced directly in playbooks and in templates, usually using the
notation `{{ var }}`.

Variable values may be simple types (string, numbers) or arrays or
maps.

Variables defined in inventory vars files (see above), directly in the
play or in explicitly included vars files:

```
- hosts: all
  remote_user: root
  vars:
    favcolor: blue
  vars_files:
    - /vars/external_vars.yml
```


## Facts, Special Variables

Facts: Pre-set Variables recording system states. To see them:
`ansible host -m setup`. Sample output (partial):

```
        "ansible_all_ipv4_addresses": [
            "10.0.2.15",
            "192.168.33.42"
        ],
        "ansible_all_ipv6_addresses": [
            "fe80::a00:27ff:fe3a:b5b",
            "fe80::a00:27ff:fe99:c3aa"
        ],
        "ansible_architecture": "x86_64",
        "ansible_bios_date": "12/01/2006",
        "ansible_bios_version": "VirtualBox",
```

Additional facts can be supplied via files
`/etc/ansible/facts.d/*.fact` containing the new facts as JSON or an
executable outputting JSON.

If a task creates a *.fact file, you may re-run the setup module in
order to use the new fact in the same play.

Fact gathering can be turned off (mainly for speed optimization, if
you know you won't need them) via `gather_facts:false`.

- Accessing variables on other hosts: `hostvars` variable. Value: map,
  keyed by hostname, of other hosts' variables. E.g.
  `hostvars[hostname][var_name]`. TODO variables or just facts?

    - only possible if `hostname` was already accessed within the same
      play or a previous play of the current playbook run. Or, you may
      enable *fact caching* in ansible.conf to cache facts between
      playbook runs.

- `group_names`: list (array) of all the groups the current host is
  in.

- `groups` dictionary mapping group names to lists of host names,
  containing all groups and hosts in the inventory. Example: Find all
  IPv4 addresses of all host in a specific group:
  
```
{% for host in groups['app_servers'] %}
   {{ hostvars[host]['ansible_eth0']['ipv4']['address'] }}
{% endfor %}
```

- `play_hosts`: list of hostnames in scope for the current play

- `inventory_dir`, `inventory_file`, `playbook_dir`, `role_path`



## Passing vars on cmd line

`ansible-playbook release.yml --extra-vars "version=1.23.45 other_variable=foo"`


## setting vars dynamically

..using special `set_fact` module.

```
tasks:
    - name: get version
      shell: "program --version"
      register: progresult
    - set_fact: progversion="{{ progresult.stdout }}"
```


# Templates

Templating language: jinja2. Used in template files and also in
expressions in yml files (in `when` and loop statements, see below).

Ansible provides some macros in addition to jinja2's builtin ones.

Macros work like this (examples):

Definedness, Default values:

`{{ some_variable | default(5) }}`

Special default value `omit`, when used for parameters, cause the
parameter to be omitted:

```
- name: touch files with an optional mode
  file: dest={{item.path}} state=touch mode={{item.mode|default(omit)}}
  with_items:
    - path: /tmp/foo
    - path: /tmp/bar
    - path: /tmp/baz
      mode: "0444"
```

List/set operations:

`{{ list1 | min }}`

`{{ [3, 4, 2] | max }}`

`unique`, `union` etc. similar.

Math:

`{{ myvar | log }}` (ln(var))



# Conditionals, Loops

Conditionals: boolean Jinja2 expressions added to tasks to determine
whether they should run or not.

```
tasks:
  - name: "shut down Debian flavored systems"
    command: /sbin/shutdown -t now
    when: ansible_os_family == "Debian"
```


# Delegations

Within a play, allow tasks to be run on another host than the one the
play is currently handling. Example:


```
- hosts: webservers
  serial: 5

  tasks:

  - name: take out of load balancer pool
    command: /usr/bin/take_out_of_pool {{ inventory_hostname }}
    delegate_to: 127.0.0.1

  - name: actual steps would go here
    yum: name=acme-web-stack state=latest

  - name: add back to load balancer pool
    command: /usr/bin/add_back_to_pool {{ inventory_hostname }}
    delegate_to: 127.0.0.1
```

Runs the first and 3rd task not on the host (out of webservers) that's
currently being handled by the play, but on
127.0.0.1. `inventory_hostname` is a predefined variable that names
the host that's currently being handled.

There is special syntax for the case that the delegated-to host is
127.0.0.1: `local_action`.

```
tasks:

  - name: recursively copy files from management server to target
    local_action: command rsync -a /path/to/files {{ inventory_hostname }}:/path/to/target/
```


# Delegated facts

If you delegate the `setup` task (which gathers facts), you can say
`delegate_facts: True` to have the resulting fact variables assigned
to the delegated-to host (just as if the setup task had run there
regularly during a play) instead of to the inventory_hostname.



TODO:

- blocks

- some special modules, e.g. group_by
