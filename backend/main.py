import uuid
from flask import Flask, request
from google.cloud import storage

from db import list_entries, add_entry

app = Flask(__name__)


@app.route('/')
def hello():
 return 'Hello World!'


@app.route('/list_all')
def list_all():
  return list_entries()


@app.route('/insert', methods=['GET'])
def upload():
  return """
<form method="POST" action="/insert" enctype="multipart/form-data">
    <input type="file" name="image">
    <input type="submit">
</form>
"""


@app.route('/insert', methods=['POST'])
def insert():
  image_url = process()
  # yo listen this was made in a hurry
  a = request.form['username']
  b = request.form['species_enum']
  c = request.form['species_desc']
  d = request.form['latitude']
  e = request.form['longitude']
  f = request.form['image_desc']
  g = request.form['date_swift']
  success = add_entry(a, b, c, d, e, image_url, f, g)
  return (image_url if success else 1)


@app.route('/upload', methods=['POST'])
def process():
  uploaded_file = request.files.get('image')
  for f in request.files:
    print(f)
  if not uploaded_file:
    return "No Image Uploaded", 400

  gcs = storage.Client()
  bucket = gcs.get_bucket("yourbucketname-1")
  blob = bucket.blob('{}-{}'.format(uuid.uuid4(), uploaded_file.filename))
  
  blob.upload_from_string(
    uploaded_file.read(),
    content_type=uploaded_file.content_type
  )

  return blob.public_url


if __name__ == '__main__':
  app.run(host='127.0.0.1', port=8080, debug=True)
