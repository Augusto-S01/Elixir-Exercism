# Analisador de Logs

Bem-vindo ao Analisador de Logs na Trilha de Elixir do Exercism.  
Se você precisar de ajuda para rodar os testes ou enviar seu código, confira o arquivo `HELP.md`.  
Se você ficar travado no exercício, veja o `HINTS.md`, mas tente resolver sem usá-los primeiro :)

## Introdução

## Expressões Regulares

As expressões regulares em Elixir seguem a especificação **PCRE** (**P**erl **C**ompatible **R**egular **E**xpressions), de forma semelhante a outras linguagens populares como Java, JavaScript ou Ruby.

O módulo `Regex` oferece funções para trabalhar com expressões regulares. Algumas funções do módulo `String` também aceitam expressões regulares como argumento.

~~~~exercism/note
Este exercício assume que você já conhece a sintaxe de expressões regulares, incluindo classes de caracteres, quantificadores, grupos e capturas.

Se precisar revisar seu conhecimento em expressões regulares, confira um desses recursos: [Regular-Expressions.info](https://www.regular-expressions.info), [Rex Egg](https://www.rexegg.com/), [RegexOne](https://regexone.com/), [Regular Expressions 101](https://regex101.com/), [RegExr](https://regexr.com/).
~~~~

### Sigils

A forma mais comum de criar expressões regulares é usando o sigil `~r`.

```elixir
~r/test/
```

Note que todos os sigils do Elixir suportam [diferentes tipos de delimitadores][sigils], não apenas `/`.

### Correspondência (Matching)

O operador `=~/2` pode ser usado para realizar uma correspondência com regex que retorna um resultado booleano. Alternativamente, existem também as funções `match?/2` no módulo `Regex` e no módulo `String`.

```elixir
"this is a test" =~ ~r/test/
# => true

String.match?("Alice has 7 apples", ~r/\d{2}/)
# => false
```

### Captura

Se uma verificação booleana simples não for suficiente, use a função `Regex.run/3` para obter uma lista com todas as capturas (ou `nil` se não houver correspondência). O primeiro elemento da lista retornada é sempre a correspondência completa da expressão regular, e os seguintes elementos são os grupos capturados.

```elixir
Regex.run(~r/(\d) apples/, "Alice has 7 apples")
# => ["7 apples", "7"]
```

### Modificadores

O comportamento de uma expressão regular pode ser modificado com flags especiais. Ao usar um sigil para criar uma expressão regular, adicione os modificadores após o segundo delimitador.

Modificadores comuns são:
- `i` – faz a correspondência ignorar maiúsculas/minúsculas (case-insensitive).
- `u` – habilita padrões específicos para Unicode como `\p` e faz com que classes de caracteres como `\w`, `\s` etc. também considerem Unicode.

```elixir
"this is a TEST" =~ ~r/test/i
# => true
```

[sigils]: https://hexdocs.pm/elixir/syntax-reference.html#sigils

## Instruções

Após uma revisão de segurança recente, foi solicitado que você limpe os arquivos de log arquivados da organização.

## 1. Identificar linhas de log corrompidas

Você precisa ter uma ideia de quantas linhas de log no seu arquivo não estão de acordo com os padrões atuais.  
Você acredita que um teste simples revela se uma linha de log é válida.  
Para ser considerada válida, uma linha deve começar com uma das seguintes strings:

- [DEBUG]
- [INFO]
- [WARNING]
- [ERROR]

Implemente a função `valid_line?/1` para retornar `true` se a linha de log for válida.

```elixir
LogParser.valid_line?("[ERROR] Network Failure")
# => true

LogParser.valid_line?("Network Failure")
# => false
```

## 2. Separar a linha de log

Logo após começar o projeto de análise de logs, você percebe que os logs de um aplicativo não estão separados em linhas como os outros.  
Neste projeto, o que deveria estar em linhas separadas, está tudo em uma única linha, conectado por setas enfeitadas como `<--->` ou `<*~*~>`.

Na verdade, qualquer string que tenha o primeiro caractere `<`, o último caractere `>`, e qualquer combinação dos seguintes caracteres `~`, `*`, `=`, e `-` no meio, pode ser usada como separador nos logs deste projeto.

Implemente a função `split_line/1`, que recebe uma linha e retorna uma lista de strings.

```elixir
LogParser.split_line("[INFO] Start.<*>[INFO] Processing...<~~~>[INFO] Success.")
# => ["[INFO] Start.", "[INFO] Processing...", "[INFO] Success."]
```

## 3. Remover artefatos do log

Você descobriu que algum processamento anterior dos logs espalhou o texto "end-of-line" seguido por um número da linha (sem espaço entre eles) ao longo dos logs.

Implemente a função `remove_artifacts/1`, que recebe uma string e remove todas as ocorrências de texto "end-of-line" (sem diferenciar maiúsculas de minúsculas) e retorna a linha do log limpa.

Linhas que não contêm o texto "end-of-line" devem ser retornadas inalteradas.

Apenas remova a string "end-of-line", não é necessário ajustar os espaços em branco.

```elixir
LogParser.remove_artifacts("[WARNING] end-of-line23033 Network Failure end-of-line27")
# => "[WARNING]  Network Failure "
```

## 4. Marcar linhas com nomes de usuário

Você notou que algumas linhas de log incluem frases que se referem a usuários.  
Essas frases sempre contêm a string `"User"`, seguida por um ou mais espaços em branco e, em seguida, o nome do usuário.  
Você decide marcar essas linhas.

Implemente a função `tag_with_user_name/1`, que processa linhas de log:

- Linhas que não contêm a string `"User"` permanecem inalteradas.
- Para linhas que contêm a string `"User"`, prefixe a linha com `[USER]` seguido pelo nome do usuário.

```elixir
LogParser.tag_with_user_name("[INFO] User Alice created a new project")
# => "[USER] Alice [INFO] User Alice created a new project"
```

Você pode assumir que:

- Cada ocorrência da string `"User"` é seguida por um ou mais espaços em branco e pelo nome do usuário.
- Há no máximo uma ocorrência da string `"User"` por linha.
- Nomes de usuário são strings não vazias que não contêm espaços.

## Fonte

### Criado por

- @angelikatyborska
