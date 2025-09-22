# Desafio Técnico: Backend - Módulo de Repasse Médico

Olá, candidato(a)! Seja bem-vindo(a) ao nosso desafio técnico. Estamos muito felizes por ter você participando do nosso processo seletivo.

Este teste foi projetado para simular um problema real que enfrentamos em nosso dia a dia e para nos dar uma visão clara de suas habilidades em arquitetura, qualidade de código e resolução de problemas.

**Não existe uma única "resposta certa".** Estamos mais interessados em entender seu processo de raciocínio, as decisões que você toma e como você as justifica. Boa sorte!

## 1. Contexto do Negócio

Você faz parte da equipe que está desenvolvendo um sistema de gestão para clínicas e hospitais. Sua tarefa é projetar e construir o serviço de backend responsável pelo **processo de fechamento de repasses médicos mensais**.

Este é um processo crítico que envolve o cálculo de pagamentos para dezenas ou centenas de médicos, baseado em milhares de procedimentos. Por isso, a solução precisa ser robusta, escalável e resiliente a falhas. O foco é exclusivamente no backend.

## 2. O Desafio

Sua tarefa é construir uma API RESTful em NestJS que orquestre o processo de fechamento de repasse. Um administrador do sistema irá disparar o processo para um determinado mês, que deve rodar em background e seguir um fluxo de estados bem definido.

### Requisitos Funcionais

1.  **Endpoint de Gatilho (Idempotente):**
    * Crie um endpoint que deve **iniciar um processo em background** para o fechamento solicitado (mês e ano) e retornar imediatamente uma resposta de sucesso.
    * **Idempotência é crucial:** Se este endpoint for chamado múltiplas vezes para o mesmo mês e ano, o processo não deve ser executado mais de uma vez. As chamadas subsequentes devem apenas retornar o status do processo já em andamento.

2.  **Processamento em Background:**
    * A lógica de cálculo dos repasses **não deve** ser executada na mesma thread do request HTTP para não travar a aplicação.

3.  **Lógica de Cálculo e Tratamento de Erros:**
    * O cálculo deve ser baseado nas regras (`percentage` ou `fixed`) definidas para cada médico.
    * Um erro no cálculo de um médico (ex: médico sem regra de repasse definida) **não deve interromper** o processamento do lote inteiro. O erro deve ser registrado (log) e o processo deve continuar para os demais médicos.

4.  **Modelo de Dados:**
    * Você deve definir e criar as tabelas necessárias no PostgreSQL. O arquivo `seed.sql` já fornece uma estrutura base, mas sinta-se à vontade para modificá-la ou estendê-la se julgar necessário.

5.  **Endpoint de Contestação:**
    * Crie um endpoint que deve permitir a alteração do status de um item de repasse específico para `CONTESTADO`.
    * A operação só deve ser permitida se o lote de repasse principal estiver no status `AGUARDANDO_CONFERENCIA`.

6.  **Endpoint de Status:**
    * Crie um endpoint para permitir que o frontend consulte o status do processo de fechamento com mês e ano (ex: `PROCESSANDO`, `AGUARDANDO_CONFERENCIA`, `FINALIZADO`).

### Requisitos Não-Funcionais

* **Escalabilidade e Resiliência:** Sua solução deve ser pensada para um alto volume de dados. Como a aplicação se recupera de uma reinicialização no meio de um processamento?
* **Testes:** Esperamos ver uma boa cobertura de testes automatizados, especialmente para a lógica de negócio e regras de cálculo.
* **Qualidade de Código:** Demonstre bons princípios de design de software (SOLID, Clean Code, etc.).

## 3. Stack Tecnológica

* **Linguagem:** TypeScript
* **Framework Backend:** NestJS
* **Banco de Dados:** PostgreSQL
* Para o processamento assíncrono, você tem liberdade de escolher a ferramenta que julgar mais adequada (ex: Bull (Redis), RabbitMQ, ou até mesmo um sistema de jobs mais simples). A escolha deve ser justificada.

## 4. Como Começar

1.  Faça um fork/clone deste repositório para sua máquina local.
2.  Configure seu ambiente
3.  Utilize o Docker Compose para subir o ambiente de desenvolvimento, incluindo o container do PostgreSQL:
    ```bash
    docker-compose up -d
    ```
5.  **Para popular o banco de dados, utilize o arquivo `seed.sql` fornecido.** Ele contém as tabelas e um volume de dados realistas para o teste. Você pode executá-lo usando um cliente de banco de dados (DBeaver, DataGrip, etc.) ou via linha de comando. Exemplo com `psql`:
    ```bash
    psql SEU_DATABASE_URL -f seed.sql
    ```

## 5. Entregáveis

Ao finalizar, por favor, nos envie o link para o **repositório privado** e adicione o usuário `MarcosGaius` como colaborador.

O repositório deve conter:
1.  Todo o código-fonte da sua solução.
2.  Este `README.md`, atualizado com quaisquer instruções adicionais que você julgar necessárias.
3.  Uma nova seção neste `README.md` chamada **"Decisões de Arquitetura"** (detalhes abaixo).

### **Decisões de Arquitetura (MUITO IMPORTANTE)**

Esta é a parte mais crítica da sua entrega. Crie uma seção detalhada explicando as escolhas que você fez e o porquê. Queremos entender seu processo de raciocínio.

**Tópicos a serem abordados:**
* Como você implementou o processamento em background e por que escolheu essa abordagem?
* Qual foi sua estratégia para garantir a idempotência do endpoint de gatilho?
* Como você estruturou o modelo de dados e por quê?
* Quais foram os principais trade-offs que você considerou?
* Se você tivesse mais tempo, o que você melhoraria na sua solução?


---
Se tiver qualquer dúvida, não hesite em nos contatar.

Bom trabalho!
