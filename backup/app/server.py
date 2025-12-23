from flask import Flask, Response, send_from_directory
import subprocess

app = Flask(__name__, static_folder="static")

@app.route("/")
def index():
    return send_from_directory("static", "index.html")

@app.route("/run")
def run():
    def stream():
        process = subprocess.Popen(
            ["sudo", "/host-scripts/backup.sh"],
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            text=True
        )

        for line in process.stdout:
            yield line + "<br>"

    return Response(stream(), mimetype="text/html")

app.run(host="0.0.0.0", port=5000)
