#!/usr/bin/env python3

from kubernetes import client, config
import flask
import requests
import os

app = flask.Flask(__name__)


ENDPOINT_NAMESPACE = os.getenv('ENDPOINT_NAMESPACE')
ENDPOINT_NAME = os.getenv('ENDPOINT_NAME')
PORT_NAME = os.getenv('PORT_NAME')



def call_ip(ip, port, url):
    full_url = f'Calling http://{ip}:{port}/{url}'
    print(f'{full_url}')
    requests.get(full_url)

@app.route('/<path:uri>', methods=['GET'])
def route_handler(uri):
    config.load_kube_config()
    v1 = client.CoreV1Api()

    #ret = v1.list_endpoints_for_all_namespaces(watch=False)
    endpoint = v1.read_namespaced_endpoints(ENDPOINT_NAME, ENDPOINT_NAMESPACE)
    for subset in endpoint.subsets:
        if subset.ports[0].name==PORT_NAME:
            for address in subset.addresses:
                call_ip(address.ip, subset.ports[0].port, uri)
    return "ok"


app.run()