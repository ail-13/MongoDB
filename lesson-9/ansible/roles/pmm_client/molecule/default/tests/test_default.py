import os

import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']).get_hosts('all')

def test_mongod_service(host):
    pbm = host.service("mongod")
    assert pbm.is_running
    assert pbm.is_enabled

def test_mongodb_running(host):
    assert host.socket("tcp://0.0.0.0:27017").is_listening

def test_mongodb_ping(host):
    with host.sudo():
        ping_user = host.run("mongo -u user -p mongo123 --quiet --eval 'db.admin.runCommand({ ping: 1 })'")
        assert '"ok" : 1' in ping_user.stdout

        ping_root = host.run("mongo -u root -p mongo123 --quiet --eval 'db.admin.runCommand({ ping: 1 })'")
        assert '"ok" : 1' in ping_root.stdout

        ping_backup = host.run("mongo -u backup -p mongo123 --quiet --eval 'db.admin.runCommand({ ping: 1 })'")
        assert '"ok" : 1' in ping_backup.stdout

def test_mongodb_replica_set(host):
    with host.sudo():
        cmd = host.run("mongo -u root -p mongo123 --quiet --eval 'rs.status().set'")
        assert cmd.stdout.strip() == 'rs0'

        cmd = host.run("mongo -u backup -p mongo123 --quiet --eval 'rs.status().set'")
        assert cmd.stdout.strip() == 'rs0'

def test_pbm_service(host):
    pbm = host.service("pbm-agent")
    assert pbm.is_running
    assert pbm.is_enabled

def test_pbm_status_command(host):
    command = host.run("pbm-agent version")
    assert command.rc == 0
    assert "Version:" in command.stdout