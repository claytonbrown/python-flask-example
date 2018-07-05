# Multi-stage build example.
# This is used when a small production Docker image is required and the python
# need to built with a "full" base image. This method is not necessary if the
# required python packages provide "many linux" wheels. The disadvantage of
# this method is that the intermediate container is not cached, so it is slower
# than a single stage build.

FROM python:3.7 as build

ADD requirements.txt /usr/src/app/
# Install required packages
RUN pip install --no-cache-dir -r /usr/src/app/requirements.txt

FROM python:3.7-slim
ENV FLASK_APP=hello.py
WORKDIR /usr/src/app

ADD . /usr/src/app
RUN python -m compileall /usr/src/app

# copy requirements from build container
COPY --from=build /usr/local/lib/python3.7/site-packages /usr/local/lib/python3.7/site-packages
COPY --from=build /usr/local/bin /usr/local/bin

EXPOSE 8000
ENTRYPOINT ["/usr/src/app/entry.sh"]
CMD ["web"]
