# Minimal Flask Application.
# See http://flask.pocoo.org/docs/0.12/quickstart/#a-minimal-application
from flask import Flask
app = Flask(__name__)

@app.route("/")
def hello():
    return "Hello World!"
