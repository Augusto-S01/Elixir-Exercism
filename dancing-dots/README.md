# Pontos Dançantes

Bem-vindo ao Pontos Dançantes na Trilha de Elixir do Exercism.
Se você precisar de ajuda para executar os testes ou enviar seu código, consulte `HELP.md`.
Se você ficar preso no exercício, consulte `HINTS.md`, mas tente resolver sem usar essas dicas primeiro :)

## Introdução

## Use

A macro `use` nos permite estender rapidamente nosso módulo com funcionalidades fornecidas por outro módulo. Quando fazemos `use` de um módulo, esse módulo pode injetar código em nosso módulo - ele pode, por exemplo, definir funções, fazer `import` ou `alias` de outros módulos, ou definir atributos de módulo.

Se você já olhou os arquivos de teste de alguns dos exercícios de Elixir aqui no Exercism, provavelmente notou que todos começam com `use ExUnit.Case`. Esta única linha de código é o que torna as macros `test` e `assert` disponíveis no módulo de teste.

```elixir
defmodule LasagnaTest do
  use ExUnit.Case

  test "minutos esperados no forno" do
    assert Lasagna.expected_minutes_in_oven() === 40
  end
end
```

### Macro `__using__/1`

O que exatamente acontece quando você faz `use` de um módulo é ditado pela macro `__using__/1` desse módulo. Ela recebe um argumento, uma lista de palavras-chave com opções, e retorna uma [expressão quoted][concept-ast]. O código nesta expressão quoted é inserido em nosso módulo ao chamar `use`.

```elixir
defmodule ExUnit.Case do
  defmacro __using__(opts) do
    # algum código real do ExUnit omitido aqui
    quote do
      import ExUnit.Assertions
      import ExUnit.Case, only: [describe: 2, test: 1, test: 2, test: 3]
    end
  end
end
```

As opções podem ser dadas como um segundo argumento ao chamar `use`, por exemplo `use ExUnit.Case, async: true`. Quando não fornecidas explicitamente, elas padrão para uma lista vazia.

## Comportamentos

Comportamentos nos permitem definir interfaces (conjuntos de funções e macros) em um _módulo de comportamento_ que podem ser posteriormente implementadas por diferentes _módulos de callback_. Graças à interface compartilhada, esses módulos de callback podem ser usados de forma intercambiável.

~~~~exercism/note
Note a grafia britânica de "behaviours".
~~~~

### Definindo comportamentos

Para definir um comportamento, precisamos criar um novo módulo e especificar uma lista de funções que fazem parte da interface desejada. Cada função precisa ser definida usando o atributo de módulo `@callback`. A sintaxe é idêntica a uma [typespec de função][concept-typespecs] (`@spec`). Precisamos especificar um nome de função, uma lista de tipos de argumentos e todos os tipos de retorno possíveis.

```elixir
defmodule Countable do
  @callback count(collection :: any) :: pos_integer
end
```

### Implementando comportamentos

Para adicionar um comportamento existente ao nosso módulo (criar um módulo de callback) usamos o atributo de módulo `@behaviour`. Seu valor deve ser o nome do módulo de comportamento que estamos adicionando.

Então, precisamos definir todas as funções (callbacks) que são requeridas por esse módulo de comportamento. Se estivermos implementando o comportamento de outra pessoa, como os comportamentos built-in do Elixir `Access` ou `GenServer`, encontraríamos a lista de todos os callbacks do comportamento na documentação em [hexdocs.pm][hexdocs].

Um módulo de callback não está limitado a implementar apenas as funções que fazem parte de seu comportamento. Também é possível para um único módulo implementar múltiplos comportamentos.

Para marcar qual função vem de qual comportamento, devemos usar o atributo de módulo `@impl` antes de cada função. Seu valor deve ser o nome do módulo de comportamento que define este callback.

```elixir
defmodule BookCollection do
  @behaviour Countable

  defstruct [:list, :owner]

  @impl Countable
  def count(collection) do
    Enum.count(collection.list)
  end

  def mark_as_read(collection, book) do
    # outra função não relacionada ao comportamento Countable
  end
end
```

### Implementações padrão de callback

Ao definir um comportamento, é possível fornecer uma implementação padrão de um callback. Esta implementação deve ser definida na expressão quoted da macro `__using__/1`. Para tornar possível que os usuários do módulo de comportamento substituam a implementação padrão, chame a macro `defoverridable/1` após a implementação da função. Ela aceita uma lista de palavras-chave com nomes de função como chaves e aridades de função como valores.

```elixir
defmodule Countable do
  @callback count(collection :: any) :: pos_integer

  defmacro __using__(_) do
    quote do
      @behaviour Countable
      def count(collection), do: Enum.count(collection)
      defoverridable count: 1
    end
  end
end
```

Note que definir funções dentro de `__using__/1` é desencorajado para qualquer outro propósito além de definir implementações padrão de callback, mas você sempre pode definir funções em outro módulo e importá-las na macro `__using__/1`.

[concept-ast]: https://exercism.org/tracks/elixir/concepts/ast
[concept-typespecs]: https://exercism.org/tracks/elixir/concepts/typespecs
[hexdocs]: https://hexdocs.pm

## Instruções

Seu amigo, um artista aspirante, entrou em contato com você com uma ideia de projeto. Vamos combinar sua criatividade visual com sua expertise técnica. É hora de mergulhar na [arte generativa][generative-art]!

Restrições ajudam a criatividade e encurtam prazos de projeto, então vocês dois concordaram em limitar sua obra-prima a uma única forma - o círculo. Mas haverão muitos círculos. E eles podem se mover! Vocês vão chamar de... pontos dançantes.

Seu amigo definitivamente vai querer criar novos movimentos elaborados para os pontos, então você começará codificando criando uma arquitetura que permitirá definir novas animações facilmente mais tarde.

## 1. Defina o comportamento de animação

Cada módulo de animação precisa implementar dois callbacks: `init/1` e `handle_frame/3`. Defina-os no módulo `Animation`.

Defina o callback `init/1`. Ele deve receber um argumento do tipo `opts` e retornar ou uma tupla `{:ok, opts}` ou uma tupla `{:error, error}`. Implementações deste callback verificarão se as opções dadas são válidas para este tipo particular de animação.

Defina o callback `handle_frame/3`. Ele deve receber três argumentos - o ponto, um número de frame e opções. Ele deve sempre retornar um ponto. Implementações deste callback modificarão os atributos do ponto baseados no número do frame atual e nas opções da animação.

## 2. Forneça uma implementação padrão do callback `init/1`

O comportamento `Animation` deve ser fácil de incorporar em outros módulos chamando `use DancingDots.Animation`.

Para fazer isso acontecer, implemente a macro `__using__` no módulo `Animation` de forma que ela defina o módulo `Animation` como o comportamento do outro módulo. Ela também deve fornecer uma implementação padrão do callback `init/1`. A implementação padrão de `init/1` deve retornar as opções dadas inalteradas.

```elixir
defmodule MyCustomAnimation do
  use DancingDots.Animation
end

MyCustomAnimation.init(some_option: true)
# => {:ok, [some_option: true]}
```

## 3. Implemente a animação `Flicker`

Use o comportamento `Animation` para implementar uma animação de piscar.

Ela deve usar o callback `init/1` padrão porque não recebe nenhuma opção.

Implemente o callback `handle_frame/3`, que manipula um único frame. Se o número do frame for um múltiplo de quatro, a função deve retornar o ponto com metade de sua opacidade original. Em outros frames, ela deve retornar o ponto inalterado.

Frames são contados a partir de `1`. O ponto passado para `handle_frame/3` é sempre o ponto em seu estado original, não no estado do frame anterior.

```elixir
dot = %DancingDots.Dot{x: 100, y: 100, radius: 24, opacity: 1}

DancingDots.Flicker.handle_frame(dot, 1, [])
# => %DancingDots.Dot{opacity: 1, radius: 24, x: 100, y: 100}

DancingDots.Flicker.handle_frame(dot, 4, [])
# => %DancingDots.Dot{opacity: 0.5, radius: 24, x: 100, y: 100}
```

## 4. Implemente a animação `Zoom`

Use o comportamento `Animation` para implementar uma animação de zoom.

Esta animação recebe uma opção - velocidade. Velocidade pode ser qualquer número. Se for negativa, o ponto fica com zoom out em vez de zoom in.

Implemente o callback `init/1`. Ele deve validar que as opções passadas são uma lista de palavras-chave com uma chave `:velocity`. O valor da velocidade deve ser um número. Se não for um número, retorne o erro `"The :velocity option is required, and its value must be a number. Got: #{inspect(velocity)}"`.

Implemente o callback `handle_frame/3`. Ele deve retornar o ponto com seu raio aumentado pelo número do frame atual, menos um, vezes a velocidade.

Frames são contados a partir de `1`. O ponto passado para `handle_frame/3` é sempre o ponto em seu estado original, não no estado do frame anterior.

```elixir
DancingDots.Zoom.init(velocity: nil)
# => {:error, "The :velocity option is required, and its value must be a number. Got: nil"}

dot = %DancingDots.Dot{x: 100, y: 100, radius: 24, opacity: 1}

DancingDots.Zoom.handle_frame(dot, 1, velocity: 10)
# => %DancingDots.Dot{radius: 24, opacity: 1, x: 100, y: 100}

DancingDots.Zoom.handle_frame(dot, 2, velocity: 10)
# => %DancingDots.Dot{radius: 34, opacity: 1, x: 100, y: 100}
```

[generative-art]: https://pt.wikipedia.org/wiki/Arte_generativa

## Fonte

### Criado por

- @angelikatyborska

### Contribuição de

- @jiegillet