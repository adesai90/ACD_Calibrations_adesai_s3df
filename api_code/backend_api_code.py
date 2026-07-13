from flask import Flask, jsonify, send_from_directory, render_template, abort
import os

app = Flask(__name__)

BASE_DIR = "/Users/aadesai1/Desktop/In_use/ACD_calibrations/reproducability_test/new_files/"


def get_calib_types():
    return sorted([
        d for d in os.listdir(BASE_DIR)
        if os.path.isdir(os.path.join(BASE_DIR, d))
    ])


def get_dates_for_calib(calib_type):
    calib_path = os.path.join(BASE_DIR, calib_type)
    if not os.path.isdir(calib_path):
        return []
    return sorted([
        d for d in os.listdir(calib_path)
        if os.path.isdir(os.path.join(calib_path, d))
    ])


def get_html_filename(calib_type, date):
    folder = os.path.join(BASE_DIR, calib_type, date)
    if not os.path.isdir(folder):
        return None
    for f in os.listdir(folder):
        if f.endswith(".html"):
            return f
    return None


@app.route("/api/calib_types")
def api_calib_types():
    return jsonify(get_calib_types())


@app.route("/api/dates")
def api_all_dates():
    all_dates = set()
    for calib in get_calib_types():
        all_dates.update(get_dates_for_calib(calib))
    return jsonify(sorted(all_dates))


@app.route("/api/available/<date>")
def api_available_for_date(date):
    available = []
    for calib in get_calib_types():
        html_name = get_html_filename(calib, date)
        if html_name:
            available.append({
                "calib_type": calib,
                "filename": html_name
            })
    return jsonify(available)


# AD changed: THIS route matches real folder depth (3 segments)
# so relative images/pdfs inside the html resolve correctly
@app.route("/report/<calib_type>/<date>/<filename>")
def serve_report_file(calib_type, date, filename):
    folder = os.path.join(BASE_DIR, calib_type, date)
    if not os.path.isdir(folder):
        abort(404)
    return send_from_directory(folder, filename)


@app.route("/")
def index():
    return render_template("index.html")

# NEW FEATURE: Compare
@app.route("/compare")
def compare_view():
    return render_template("compare.html")



if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)