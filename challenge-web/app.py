import os
from flask import Flask, render_template, request, redirect, url_for, session

app = Flask(__name__)
app.secret_key = os.environ["NF03_FLASK_SECRET"]

# ---------------------------------------------------------
# Synthetic CTF account supplied through the NF02 hand-off.
# ---------------------------------------------------------
USERS = {
    "fieldtech": {
        "password": os.environ["NF03_PASSWORD"],
        "display_name": "Field Operations Technician",
        "clearance": "FIELD-1",
        "assigned_incidents": [1042],
    }
}


# ---------------------------------------------------------
# Synthetic incident records used only by the CTF.
# ---------------------------------------------------------
INCIDENTS = {
    1042: {
        "id": 1042,
        "title": "Telemetry Relay Interruption",
        "classification": "FIELD",
        "status": "Open",
        "location": "Relay Sector C",
        "owner": "Field Operations",
        "summary": (
            "Intermittent telemetry loss was detected during routine "
            "relay validation. Field personnel were assigned to verify "
            "local equipment and uplink stability."
        ),
        "notes": (
            "Initial inspection found no evidence of permanent hardware "
            "failure. Continue monitoring during the next validation cycle."
        ),
    },

    1043: {
        "id": 1043,
        "title": "Prototype Access Review",
        "classification": "RESTRICTED",
        "status": "Archived",
        "location": "Prototype Engineering",
        "owner": "NIGHTFALL Programme",
        "summary": (
            "Post-demonstration review of access activity associated with "
            "the NIGHTFALL prototype environment."
        ),
        "notes": (
            "The review identified an authorization boundary failure in "
            "the incident-record service. Restricted programme records "
            "were accessible through direct object references."
        ),
        "flag": os.environ["NF03_FLAG"],
	"handoff": {
   		 "case_id": "CYG-NF-1043",
   		 "evidence_bundle": "nightfall_capture.pcapng",
   		 "supporting_log": "access.log",
   		 "time_window": "2026-07-21 21:40-21:50 UTC",
	},
    },

    1044: {
        "id": 1044,
        "title": "Environmental Sensor Calibration",
        "classification": "INTERNAL",
        "status": "Closed",
        "location": "Lab Annex B",
        "owner": "Facilities Engineering",
        "summary": (
            "Routine calibration discrepancy reported by environmental "
            "monitoring equipment."
        ),
        "notes": (
            "Sensor array recalibrated successfully. No further action "
            "required."
        ),
    },
}


@app.route("/")
def home():
    return redirect(url_for("incident_review"))


@app.route("/incident-review", methods=["GET", "POST"])
def incident_review():
    if session.get("username"):
        return redirect(url_for("dashboard"))

    error = None

    if request.method == "POST":
        username = request.form.get("username", "").strip()
        password = request.form.get("password", "")

        user = USERS.get(username)

        if user and user["password"] == password:
            session["username"] = username
            return redirect(url_for("dashboard"))

        error = "Authentication failed. Verify your assigned credentials."

    return render_template("login.html", error=error)


@app.route("/incident-review/dashboard")
def dashboard():
    username = session.get("username")

    if not username or username not in USERS:
        return redirect(url_for("incident_review"))

    user = USERS[username]

    assigned_records = [
        INCIDENTS[incident_id]
        for incident_id in user["assigned_incidents"]
        if incident_id in INCIDENTS
    ]

    return render_template(
        "dashboard.html",
        user=user,
        incidents=assigned_records,
    )


@app.route("/incident-review/records/<int:incident_id>")
def incident_record(incident_id):
    username = session.get("username")

    if not username or username not in USERS:
        return redirect(url_for("incident_review"))

    incident = INCIDENTS.get(incident_id)

    if not incident:
        return (
            render_template(
                "incident.html",
                incident=None,
                user=USERS[username],
            ),
            404,
        )

    # -----------------------------------------------------
    # INTENTIONAL CTF VULNERABILITY — NF03
    #
    # Authentication is checked above, but object-level
    # authorization is deliberately missing here.
    #
    # The application should verify that incident_id belongs
    # to USERS[username]["assigned_incidents"] before returning
    # the record. It intentionally does not do so because NF03
    # demonstrates an IDOR/BOLA authorization failure.
    # -----------------------------------------------------

    return render_template(
        "incident.html",
        incident=incident,
        user=USERS[username],
    )


@app.route("/incident-review/logout")
def logout():
    session.clear()
    return redirect(url_for("incident_review"))


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
