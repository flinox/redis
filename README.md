# Redis docker

Imagem para rodar o redis passando argumentos e arquivo de configuracao como parametros em uma variavel de ambiente e com lista de usuários ( ACL )


## Buildar a imagem do redis

```
docker build -f Dockerfile -t redis-sbx:test ./conf
```

## Rodando a imagem do redis

```
docker run --rm \
-p 6379:6379 \
-v ./data:/data \
-v ./conf/redis.conf:/usr/local/etc/redis/redis.conf \
-v ./conf/redis_start.sh:/usr/local/bin/redis_start.sh \
-v ./users:/etc/redis \
-e REDIS_ARGS="/usr/local/etc/redis/redis.conf --save 60 1000 --appendonly yes --loglevel debug" \
redis-sbx:test
```


## redis.conf

Armazenado em: /conf/redis.conf

Está liberado conexão apenas local.

```
bind 127.0.0.1
```

Para liberar para todas as origens use:

```
bind 0.0.0.0
```
O que não é recomendado, libere apenas o range que precisará de acesso ao redis.


## data

Dados do redis

Armazenado em: /data

## users

Usuarios ACL para acesso e consumo dos dados do redis.

Armazenado em: /users



## Configurando usuarios

A Primeira execução não terá usuários criados.

Siga os passos abaixo para configurar o Redis ACL ( Access Control List )

Acesse o redis:
```
redis-cli -h 127.0.0.1 -p 6379
```

Teste o redis:
```
PING
```
Resposta esperada: PONG


Gere uma senha forte:
```
echo $(cat /dev/urandom | tr -dc 'A-Za-z0-9_#!<>;:/?@%*()\-+' | fold -w 256 | head -n 1)
```

Configure a senha para o usuário 'default'

```
CONFIG SET requirepass <senha-forte>
```

Teste a autenticacao com essa senha definida:

```
AUTH default <senha-forte>
```

Crie um novo usuário para o sistema que deverá usar o redis:

```
ACL SETUSER <novo-usuario> on ><nova-senha-forte> ~* &* +@all
```

Para saber todas as permissões consulte:
![https://miro.medium.com/v2/resize:fit:720/format:webp/1*M9UUCbqDvVQW96U4UupSGA.jpeg](https://miro.medium.com/v2/resize:fit:720/format:webp/1*M9UUCbqDvVQW96U4UupSGA.jpeg)

Fonte: https://medium.com/aeturnuminc/securing-redis-with-access-control-lists-acls-54623606f411

Ao final, para persistir as configurações no arquivo users.acl, rode:

```
ACL SAVE
```

## Referencias
- https://redis.io/docs/latest/operate/oss_and_stack/management/security/acl/
- https://redis.io/docs/latest/operate/rc/security/access-control/data-access-control/configure-acls/#:~:text=ACLs%20that%20are%20not%20marked%20with%20the%20Redis,and%20select%20the%20pencil%20icon%20to%20edit%20it.