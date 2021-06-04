# magalu-tdc-kong-plugin

## Comandos

Criar Rockspec
```bash
luarocks write_rockspec --lua-versions "5.1"
                        --homepage "https://github.com/allbarbos/kong-plugin-magalu-tdc"
                        kong-plugin-magalu-tdc
                        1.0.0
                        ./
```

Iniciar Pongo
```bash
pongo init
```

Teste de integração
```bash
make integration
```

Teste unitário
```bash
make unit
```

Coverage
```bash
make cov
```
