import os

import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']).get_hosts('all')

def test_express_app_running(host):
    assert host.socket("tcp://0.0.0.0:3000").is_listening
    cmd = host.run("curl http://localhost:3000")
    assert cmd.stdout.strip() == "OK"