from invoke import task

@task
def clean(c):
    c.run("rm -rf **/*.pyc")

@task
def build(c):
    c.run("pip3 install -r requirements.txt")

@task
def test(c):
    c.run("pytest tests/*")