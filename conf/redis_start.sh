#!/bin/bash

# Verifica se a variável de ambiente REDIS_ARGS está definida
if [ -n "$REDIS_ARGS" ]; then
    # Se estiver definida, usa-a como argumento para o redis-server
    echo "Rodando redis com argumentos!"
    exec redis-server $REDIS_ARGS
else
    # Se não, inicia o redis-server sem argumentos adicionais
    echo "Rodando redis!"
    exec redis-server
fi