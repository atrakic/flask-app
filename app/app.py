import os
import json
import redis

from datetime import datetime
from flask import Flask, jsonify

VERSION = os.getenv('VERSION', "0.1.0")
REDIS_ENDPOINT = os.getenv("REDIS_ENDPOINT", "localhost")
REDIS_PORT = int(os.getenv("REDIS_PORT", "6379"))

application = Flask(__name__)

@application.route("/")
def get_var():
    """Get the time"""
    red = redis.StrictRedis(host=REDIS_ENDPOINT, port=REDIS_PORT, db=0)
    return json.dumps({"time": str(red.get("time"))})

@application.route("/set")
def set_var():
    """Set the time"""
    red = redis.StrictRedis(host=REDIS_ENDPOINT, port=REDIS_PORT, db=0)
    red.set("time", str(datetime.now()))
    return json.dumps({"time": str(red.get("time"))})

@application.route("/reset")
def reset():
    """Reset the time"""
    red = redis.StrictRedis(host=REDIS_ENDPOINT, port=REDIS_PORT, db=0)
    red.delete("time")
    return json.dumps({"time": str(red.get("time"))})

@application.route("/version")
def version():
    """Get the app version"""
    return json.dumps({"version": VERSION})

@application.route("/health")
def health():
    """Check the app health"""
    try:
        red = redis.StrictRedis(host=REDIS_ENDPOINT, port=REDIS_PORT, db=0)
        red.ping()
    except redis.exceptions.ConnectionError:
        return json.dumps({"status": false})
    return json.dumps({"status": red.ping()})

if __name__ == "__main__":
    application.run(host="0.0.0.0")
