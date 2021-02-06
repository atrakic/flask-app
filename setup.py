from setuptools import setup

packages = []
with open("requirements.txt", "r") as f:
    requirements = f.read().splitlines()

setup(
    name="flask-app",
    version="0.1.0",
    description="example api with Redis",
    url="http://github.com/atrakic/flask-app",
    author="Admir Trakic",
    author_email="xomodo@gmail.com",
    license="MIT",
    include_package_data=True,
    install_requires=requirements,
    packages=packages,
    zip_safe=False,
    classifiers=[
        "Programming Language :: Python :: 3",
        "Intended Audience :: Developers",
    ],
)
