from bottle import Bottle, run, static_file

from routes import events, auth

app = Bottle()


@app.route("/static/<filepath:path>")
def serve_static(filepath):
    return static_file(filepath, root="./static")


events.register(app)
auth.register(app)


if __name__ == "__main__":
    run(app, host="0.0.0.0", port=8080, debug=True, reloader=True)
