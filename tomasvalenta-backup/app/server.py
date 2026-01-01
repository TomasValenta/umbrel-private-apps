from flask import Flask, Response, send_from_directory
import subprocess

app = Flask(__name__, static_folder="static")

@app.route("/")
def index():
    return send_from_directory("static", "index.html")

@app.route("/check")
def check():
    try:
        subprocess.check_call(
            ["mount", "/media/backup"],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
        )

        subprocess.check_call(
            ["umount", "/media/backup"],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
        )

        return {"ok": True}

    except subprocess.CalledProcessError:
        return {
            "ok": False,
            "error": "Mount /media/backup selhal – pravděpodobně chybí fstab konfigurace"
        }

@app.route("/run")
def run():
    def stream():
        process = subprocess.Popen(
            ["/scripts/backup.sh"],
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            text=True
        )
        for line in process.stdout:
            yield line + "<br>"
    
    return Response(stream(), mimetype="text/html")

app.run(host="0.0.0.0", port=5000)
