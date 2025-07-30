# Take-A-Number Deluxe

Bem-vindo ao Take-A-Number Deluxe na Trilha de Elixir do Exercism.
Se você precisar de ajuda para rodar os testes ou enviar seu código, veja `HELP.md`.
Se ficar preso no exercício, veja `HINTS.md`, mas tente resolvê-lo sem usá-los primeiro :)

## Introdução

## GenServer

`GenServer` (servidor genérico) é um [comportamento][concept-behaviours] que abstrai interações comuns de cliente-servidor entre processos Elixir.

Lembra do loop de recebimento quando aprendemos sobre [processos][concept-processes]? O comportamento `GenServer` fornece abstrações para implementar tais loops e para trocar mensagens com um processo que executa esse loop. Ele facilita manter estado e executar código assíncrono.

~~~~exercism/note
Atenção que o nome `GenServer` tem muitos significados. Ele também é usado para descrever um _módulo_ que _usa_ o comportamento `GenServer`, assim como um _processo_ que foi iniciado a partir de um módulo que _usa_ esse comportamento.
~~~~

O comportamento `GenServer` define uma callback obrigatória, `init/1`, e algumas opcionais: `handle_call/3`, `handle_cast/2` e `handle_info/3`. Os _clientes_ que usam um `GenServer` não devem chamar essas callbacks diretamente. Em vez disso, o módulo `GenServer` fornece funções para que os clientes possam se comunicar com um processo `GenServer`.

Frequentemente, um único módulo define tanto uma _API do cliente_, um conjunto de funções que outras partes do seu app Elixir podem chamar para se comunicar com esse processo `GenServer`, quanto _implementações de callbacks do servidor_, que contêm a lógica desse `GenServer`.

Vamos primeiro ver um exemplo simples de um `GenServer`, e depois entender o que cada callback faz.

### Exemplo

Este é um servidor de exemplo que responde às perguntas repetitivas de passageiros irritantes durante uma longa viagem, mais especificamente: "já chegamos?". Ele mantém o controle de quantas vezes essa pergunta foi feita, retornando respostas cada vez mais irritadas.

```elixir
defmodule AnnoyingPassengerAutoresponder do
  use GenServer
  # API do cliente

  def start_link(init_arg) do
    GenServer.start_link(__MODULE__, init_arg)
  end

  def are_we_there_yet?(pid) do
    GenServer.call(pid, :are_we_there_yet?)
  end

  # Callbacks do servidor

  @impl GenServer
  def init(_init_arg) do
    state = 0
    {:ok, state}
  end

  @impl GenServer
  def handle_call(:are_we_there_yet?, _from, state) do
    reply =
      cond do
        state <= 3 -> "Não."
        state <= 10 -> "Eu já te disse #{state} vezes. Não."
        true -> "..."
      end

    new_state = state + 1
    {:reply, reply, new_state}
  end
end
```

### Callbacks

#### `init/1`

Um servidor pode ser iniciado com `GenServer.start/3` ou `GenServer.start_link/3`. Aprendemos a diferença entre essas funções no conceito de [links][concept-links].

Essas funções:

- Aceitam um módulo que implementa o comportamento `GenServer` como primeiro argumento.
- Aceitam qualquer coisa como segundo argumento, chamado `init_arg`. Este será passado para o callback `init/1`.
- Aceitam um terceiro argumento opcional com configurações avançadas que não abordaremos agora.

Iniciar o servidor com `GenServer.start/3` ou `GenServer.start_link/3` chama o `init/1` de forma bloqueante. O valor de retorno de `init/1` determina se o servidor será iniciado com sucesso.

Os retornos possíveis de `init/1` incluem:

- `{:ok, state}`: o servidor começa com o estado `state`.
- `{:stop, reason}`: o servidor não será iniciado; o processo terminará com o motivo `reason`.

Se o loop do servidor iniciar, `GenServer.start/3` e `GenServer.start_link/3` retornam `{:ok, pid}`. Caso contrário, retornam `{:error, reason}`.

#### `handle_call/3`

Mensagens que exigem resposta podem ser enviadas com `GenServer.call/2`. Essa função recebe o `pid` e a mensagem.

O callback `handle_call/3` trata mensagens síncronas. Ele recebe três argumentos:

1. `message`: a mensagem enviada.
2. `from`: o `pid` do processo chamador (geralmente pode ser ignorado).
3. `state`: o estado atual do servidor.

Ele normalmente retorna `{:reply, reply, state}`.

~~~~exercism/note
Para memorizar o que esse callback faz, pense que é como "ligar para alguém".  
Se essa pessoa estiver disponível, você receberá uma resposta imediatamente (sincronamente).
~~~~

#### `handle_cast/2`

Mensagens que não exigem resposta podem ser enviadas com `GenServer.cast/2`.

O callback `handle_cast/2` recebe dois argumentos: `message` e `state`.

Ele normalmente retorna `{:noreply, state}`.

~~~~exercism/note
Para lembrar o que esse callback faz, pense que "cast" também significa "lançar".

Se você lança uma garrafa com mensagem ao mar,
não espera uma resposta imediata — ou talvez nunca receba.
~~~~

#### Devo usar `call` ou `cast`?

Quase sempre use `call`, mesmo que o cliente não precise da resposta.

`call` espera a resposta, o que funciona como um mecanismo de controle de fluxo. Também é a única forma de garantir que o servidor recebeu e tratou a mensagem.

#### `handle_info/2`

Mensagens também podem ser enviadas com `send/2`.

Para tratá-las, use o callback `handle_info/2`, que funciona igual ao `handle_cast/2`.

O comportamento `GenServer` fornece uma implementação padrão que registra erro em caso de mensagens inesperadas. Se sobrescrever, inclua seu próprio tratamento para mensagens desconhecidas, ou o servidor pode falhar.

### Timeouts

O valor de retorno das callbacks pode incluir um timeout. Por exemplo, em vez de `{:ok, state}`, retorne `{:ok, state, timeout}`.

Se esse timeout for alcançado sem mensagens recebidas, o `handle_info/2` será chamado com `:timeout`.

[concept-behaviours]: https://exercism.org/tracks/elixir/concepts/behaviours  
[concept-processes]: https://exercism.org/tracks/elixir/concepts/processes  
[concept-links]: https://exercism.org/tracks/elixir/concepts/links  

## Instruções

A máquina Take-A-Number básica vendeu muito bem, mas alguns usuários reclamaram da falta de recursos avançados comparado com modelos concorrentes.

O fabricante ouviu os feedbacks e decidiu lançar um modelo deluxe com mais recursos. Sua tarefa é implementar o software para essa máquina.

Os novos recursos incluem:

- Controlar os números atualmente na fila.
- Definir número mínimo e máximo (para separar filas por setor, por exemplo).
- Permitir prioridade para certos números (idosos e gestantes).
- Desligamento automático após inatividade.

A lógica da máquina foi implementada pelo seu colega em `TakeANumberDeluxe.State`. Sua tarefa é encapsular isso em um `GenServer`.

## 1. Inicie a máquina

Use o comportamento `GenServer` no módulo `TakeANumberDeluxe`.

Implemente `start_link/1` e o callback necessário.

O argumento é uma keyword list com `:min_number` e `:max_number`. Passe esses valores para `TakeANumberDeluxe.State.new/2`.

Se retornar `{:ok, state}`, a máquina deve iniciar. Se retornar `{:error, error}`, ela deve parar com o erro como motivo.

```elixir
TakeANumberDeluxe.start_link(min_number: 1, max_number: 9)
# => {:ok, #PID<0.174.0>}

TakeANumberDeluxe.start_link(min_number: 9, max_number: 1)
# => {:error, :invalid_configuration}
```

A função `TakeANumberDeluxe.State.new/2` também aceita um terceiro argumento opcional `auto_shutdown_timeout`, que será usado depois.

## 2. Relatar o estado da máquina

Implemente `report_state/1` e o callback necessário. A máquina deve responder com o estado atual.

```elixir
{:ok, machine} = TakeANumberDeluxe.start_link(min_number: 1, max_number: 10)
TakeANumberDeluxe.report_state(machine)
# => %TakeANumberDeluxe.State{
#      max_number: 10,
#      min_number: 1,
#      queue: %TakeANumberDeluxe.Queue{in: [], out: []},
#      auto_shutdown_timeout: :infinity,
#    }
```

## 3. Adicionar novos números à fila

Implemente `queue_new_number/1` e o callback necessário.

Deve chamar `TakeANumberDeluxe.State.queue_new_number/1`.

Se retornar `{:ok, new_number, new_state}`, a máquina responde com o número e atualiza o estado. Se for `{:error, error}`, responde com o erro e mantém o estado.

```elixir
{:ok, machine} = TakeANumberDeluxe.start_link(min_number: 1, max_number: 2)
TakeANumberDeluxe.queue_new_number(machine)
# => {:ok, 1}

TakeANumberDeluxe.queue_new_number(machine)
# => {:ok, 2}

TakeANumberDeluxe.queue_new_number(machine)
# => {:error, :all_possible_numbers_are_in_use}
```

## 4. Servir o próximo número da fila

Implemente `serve_next_queued_number/2` e o callback necessário.

Deve chamar `TakeANumberDeluxe.State.serve_next_queued_number/2`.

Se retornar `{:ok, next_number, new_state}`, a máquina responde com o número e atualiza o estado. Se for erro, responde com ele e não muda o estado.

```elixir
{:ok, machine} = TakeANumberDeluxe.start_link(min_number: 1, max_number: 10)
TakeANumberDeluxe.queue_new_number(machine)
# => {:ok, 1}

TakeANumberDeluxe.serve_next_queued_number(machine)
# => {:ok, 1}

TakeANumberDeluxe.serve_next_queued_number(machine)
# => {:error, :empty_queue}
```

## 5. Resetar o estado

Implemente `reset_state/1` e o callback necessário.

Deve chamar `TakeANumberDeluxe.State.new/2` com `min_number` e `max_number` atuais. O novo estado deve ser configurado. Não deve haver resposta ao chamador.

```elixir
{:ok, machine} = TakeANumberDeluxe.start_link(min_number: 1, max_number: 10)

TakeANumberDeluxe.reset_state(machine)
# => :ok
```

## 6. Implementar desligamento automático

Modifique o início da máquina para ler a chave `:auto_shutdown_timeout` e passá-la como terceiro argumento para `TakeANumberDeluxe.State.new/3`. Use `:infinity` como padrão.

Modifique também o reset para passar `auto_shutdown_timeout`.

Atualize os retornos das callbacks (`init/1`, `handle_*`) para incluir o timeout baseado no estado.

Implemente o callback para `:timeout`, encerrando o processo com razão `:normal`.

Também trate mensagens inesperadas ignorando-as.

```elixir
{:ok, machine} =
  TakeANumberDeluxe.start_link(
    min_number: 1,
    max_number: 10,
    auto_shutdown_timeout: :timer.hours(2)
  )

# depois de 3 horas...

TakeANumberDeluxe.queue_new_number(machine)
# => ** (exit) exited in: GenServer.call(#PID<0.171.0>, :queue_new_number, 5000)
#        ** (EXIT) no process: o processo não está vivo ou não está associado a esse nome
#       (elixir 1.13.0) lib/gen_server.ex:1030: GenServer.call/3
```

## Fonte

### Criado por

- @angelikatyborska

### Contribuído por

- @jiegillet
