from flask import Flask

app = Flask(__name__)

@app.route("/")
def home():
    return """
    <html>
        <head>
            <title>Cygnus Labs - Dev Portal</title>
        </head>
        <body>
            <h1>Cygnus Labs Developer Portal</h1>
            <p>Operation NIGHTFALL</p>
            <p>Development environment online.</p>
        </body>
    </html>
    """

app.run(host="0.0.0.0", port=5000)