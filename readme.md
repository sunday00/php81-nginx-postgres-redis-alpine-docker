# Should Config
- mv .env.example .env
- mv redis/conf/users.example.acl /redis/conf/users.acl

# Setting Service
- index.html | index.php should in ./src/current/public
- laravel - laravel new current

# run
```
docker compose -f docker-compose.yml -f docker-compose.prod.yml up -d --build nginx
```