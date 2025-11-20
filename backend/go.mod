module github.com/jonas59075/BerlinClock/backend

go 1.22.12

require github.com/jonas59075/BerlinClock/backend/api v0.0.0-20251120150102-269fce8d4932

replace github.com/jonas59075/BerlinClock/backend/api => ./api

require github.com/gorilla/mux v1.8.1 // indirect
