# docker-phpmyadmin
============================
https://registry.hub.docker.com/u/wnameless/mysql-phpmyadmin/ with bind address

```
docker pull erwasambo/phpmyadmin
```

Run with 22, 80 and 3306 ports opened:
```
docker run -d -p 80:80 -p 3306:3306 erwasambo/phpmyadmin
```

Open http://localhost:49161/phpmyadmin in your browser with following credential:
```
username: root
password:
```

Login by SSH
```
ssh root@localhost -p 49160
password: admin
```

