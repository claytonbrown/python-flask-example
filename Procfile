# Example Procfile.
# This provides an alias to the entrypoint process for the container.
# Multiple processes can be defined but only one can be run.
web: gunicorn -b 0.0.0.0:8000 hello:app
dev_web: flask run --host=0.0.0.0 --port=8000
