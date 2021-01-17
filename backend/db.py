#db.py
import os
import pymysql
from flask import jsonify

db_user = os.environ.get('CLOUD_SQL_USERNAME')
db_password = os.environ.get('CLOUD_SQL_PASSWORD')
db_name = os.environ.get('CLOUD_SQL_DATABASE_NAME')
db_connection_name = os.environ.get('CLOUD_SQL_CONNECTION_NAME')

def open_connection():
  try:
    return pymysql.connect(user=db_user, password=db_password,
                           host=db_connection_name, database=db_name,
                           cursorclass=pymysql.cursors.DictCursor)
  except pymysql.MySQLError as e:
    print(e)

def list_entries():

  conn = open_connection()
  entries = "{}"
  with conn.cursor() as cursor:

    cursor.execute("SELECT username, species_enum, species_desc, latitude, longitude, image_url, image_desc, date_swift FROM disc ORDER BY date_system DESC")

    entries = cursor.fetchall()
    entries = jsonify(entries)

  conn.close()
  return entries

def add_entry(user, sp_enum, sp_desc, lat, lon, img_url, img_desc, date_swift):

  # db formatting
  user = user[0:32]
  sp_desc = sp_desc[0:64]
  img_desc = img_desc[0:255]

  # insert operations
  conn = open_connection()
  with conn.cursor() as cursor:

    top_sql = """INSERT INTO disc(username, species_enum, species_desc, latitude, longitude, image_url, image_desc, date_swift) VALUES"""
    val_sql = "('{}', '{}', '{}', '{}', '{}', '{}', '{}', '{}')".format(user, sp_enum, sp_desc, lat, lon, img_url, img_desc, date_swift)

    sql_string = top_sql + val_sql
    cursor.execute(sql_string)
    conn.commit()
    conn.close()
    return True

  # fail
  conn.close()
  return False
