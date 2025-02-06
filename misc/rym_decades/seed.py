import sqlite3
from pathlib import Path

def ready():
  f = open("songs.txt", "r")

  res = []
  for i, line in enumerate(f):
    if not i % 7:
      res.append(())
    res[-1] += (line.strip(),)
  return res

Path('songs.db').touch()
conn = sqlite3.connect('songs.db')
cursor = conn.cursor()

cursor.execute('''
CREATE TABLE IF NOT EXISTS songs (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  album TEXT,
  song TEXT NOT NULL,
  release TEXT,
  artist TEXT,
  genre TEXT,
  rating REAL,
  votes TEXT
)
''')

for record in ready():
  if len(record) == 7:
    cursor.execute('''
    INSERT INTO songs (album, song, release, artist, genre, rating, votes)
    VALUES (?, ?, ?, ?, ?, ?, ?)
    ''', record)
  else:
    print(f'Skipping {record}')

conn.commit()
conn.close()
