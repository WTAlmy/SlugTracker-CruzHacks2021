# CruzHacks 2021 - Slug Tracker

Not all assets available:
- XCode Pod sizes exceed GitLab free tier maximum
- Login Scripts / Authentication Credentials Removed

## Showcase Link:
https://devpost.com/software/slug-tracker-modify

## Technical Details:
Front End:
- Written in Swift 5 for iOS 14.3
- Google Maps API used to place coordinate markers on satellite map

Back End:
- Python 3.7 Flask application running with gunicorn WSGI server
- Deployed on Google Cloud App Engine
- Google Cloud SQL Database (MySQL 5) used to host "discovery" metadata, image URLs, and login information
- Google Cloud Storage buckets used to host images uploaded by users, and provide a public URL to view them
