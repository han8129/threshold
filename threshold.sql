CREATE TABLE "exercises" (
	"id"	TEXT NOT NULL UNIQUE,
	"name"	TEXT NOT NULL,
	"rest_minutes"	REAL NOT NULL,
	"sets"	INTEGER NOT NULL,
	"reps"	INTEGER NOT NULL,
	PRIMARY KEY("id")
)

CREATE TABLE "records" (
	"id"	TEXT NOT NULL UNIQUE,
	"exercise_id"	TEXT NOT NULL,
	"date"	TEXT NOT NULL,
	"duration_seconds"	REAL NOT NULL,
	"note"	TEXT,
	PRIMARY KEY("id"),

	getAll()
	FOREIGN KEY("exercise_id") REFERENCES "exercises"("id") ON DELETE CASCADE on UPDATE CASCADE
)
