up:            ## поднять БД в фоне
	docker-compose up -d

logs:          ## смотреть логи Postgres
	docker-compose logs -f postgres

psql:          ## открыть psql внутри контейнера
	docker-compose exec postgres psql -U $$POSTGRES_USER -d $$POSTGRES_DB

drop:          ## снести контейнер и данные
	docker-compose down -v
