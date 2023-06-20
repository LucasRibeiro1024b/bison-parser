# README

Para executar o programa utilize:

```bash
    flex sample.l && bison -d sample.y && gcc lex.yy.c sample.tab.c string_util.c -lm -lfl -o exec && ./exec
```

Observações:
    Todas as variáveis precisam ser declaradas antes. Para que os exemplos funcionem faça:

```bash
    int x;
    int y;
    int ap1;
    int ap2;
    float med;
    float taxa;
    float base;
```

Exemplos de entrada:

```bash
    x = y;
    med = (ap1 + ap2 + a)/3;
    taxa = base * 0,1;
```