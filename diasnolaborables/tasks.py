from invoke import task, call

@task
def clean(c):
    c.run("rm -rf **/*.pyc **/__pycache__ .pytest_cache/")

@task(pre=[clean])
def build(c):
    c.run("pip3 install -r requirements.txt")

@task(optional=['dir'])
def test(c, dir='tests'):
    c.run("pytest {}/*".format(dir))

@task(optional=['port'])
def run_server(c, port=8000):
    c.run("gunicorn --chdir src app:app -b 0.0.0.0:{} --log-syslog".format(port))

@task(optional=['tag', 'no-cache'])
def build_image(c, tag='diasnolaborables', cache=True):
    nocache = '' if cache else '--no-cache '
    c.run("docker build {}-t {} .".format(nocache, tag))

@task(optional=['all', 'name'])
def remove_container(c, all=False, name='diasnolaborables'):
    if all:
        c.run("docker container prune")
    else:
        c.run("docker rm {}".format(name))

@task(optional=['port', 'name', 'image'])
def run_image(c, port=8000, name='diasnolaborables', image='diasnolaborables'):
    c.run("docker run -p {}:{} --env PORT={} --name {} {}".format(port, port, port, name, image))

@task(optional=['name'])
def stop_container(c, name='diasnolaborables'):
    c.run("docker stop {}".format(name))