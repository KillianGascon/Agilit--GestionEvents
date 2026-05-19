from bottle import Bottle, run

app = Bottle()


@app.route("/")
def index():
    return "GestionEvents"


if __name__ == "__main__":
    run(app, host="0.0.0.0", port=8080, debug=True, reloader=True)
