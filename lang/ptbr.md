# MultiJuicer-Security-Constest-Server

*[Read in English](../README.md)*

Implantação automatizada do OWASP MultiJuicer em um cluster K3s local para hospedar eventos de CTF de cibersegurança.

O objetivo deste repositório é fornecer um ambiente simples, automatizado e pronto para uso (*ready-to-go*) para hospedar competições locais de cibersegurança do tipo *Capture The Flag* (CTF). Através de um único script, é possível implantar toda a infraestrutura necessária para suportar diversas equipes (instâncias do OWASP Juice Shop).

## Visão Geral da Arquitetura

Para sustentar o evento, este projeto integra três tecnologias fundamentais:

*   [**OWASP Juice Shop**](https://owasp.org/projects/juice-shop): Uma aplicação web insegura moderna e sofisticada. Ela é intencionalmente desenvolvida com diversas falhas de segurança (como SQL Injection, XSS e falhas de autenticação) para ser usada em treinamentos e competições de cibersegurança.
*   [**MultiJuicer**](https://pwning.owasp-juice.shop/companion-guide/latest/part4/multi-juicer.html): Em um CTF padrão, se todos os participantes atacarem uma única instância do Juice Shop, as ações de um jogador podem derrubar o servidor e arruinar a competição para todos. O MultiJuicer resolve isso gerenciando o tráfego e criando instâncias isoladas do Juice Shop dinamicamente dentro de um cluster Kubernetes. Cada equipe ou jogador recebe um ambiente exclusivo e isolado (*sandbox*).
*   [**K3s**](https://k3s.io): Uma distribuição Kubernetes altamente disponível e extremamente leve. Em vez de depender de máquinas virtuais pesadas ou configurações complexas de nuvem, o K3s roda diretamente na máquina host com o mínimo de sobrecarga. Isso garante que o máximo de CPU e RAM seja preservado para as instâncias reais dos contêineres do CTF, tornando-o o motor de orquestração perfeito para laboratórios locais e ambientes *bare-metal*.

<p align="center">
    <img src="../assets/architecture.svg" alt="Architecture" width="60%">
</p>

## Pré-requisitos e Diretrizes Críticas

Antes de iniciar a implantação, siga estritamente as seguintes regras de infraestrutura:

1. **Sistema Operacional:** Este ambiente foi projetado exclusivamente para sistemas Linux (Ubuntu 20.04, 22.04 ou 24.04 é altamente recomendado).
2. **Conexão Cabeada Obrigatória:** A máquina que atuará como servidor host deve estar conectada à internet via cabo de rede (Ethernet).
    * *Nota sobre Isolamento de Rede:* Se você hospedar o servidor em uma conexão Wi-Fi, as regras de segurança padrão dos roteadores (como Isolamento de LAN/AP/Cliente) podem restringir a rede. Nesse cenário, apenas os dispositivos conectados exatamente à mesma rede Wi-Fi conseguirão ver e acessar a competição.
3. **Gerenciamento de Recursos:** Executar múltiplos contêineres simultaneamente exige recursos significativos do sistema (CPU e RAM). Assim que o servidor estiver rodando, feche todos os navegadores web e aplicativos em segundo plano, deixando apenas o terminal aberto. Isso garante que a máquina tenha o máximo de recursos disponíveis para manter a estabilidade durante o evento.

## Instruções de Implantação

O script de implantação não será executado sem as permissões adequadas do sistema. Para iniciar o ambiente, abra seu terminal no diretório do projeto e siga estes dois passos:

**1. Conceda a permissão de execução (Obrigatório):**
```bash
chmod +x setup-ctf-up.sh

```

**2. Execute o script de instalação:**

```bash
./setup-ctf-up.sh

```

O script cuidará automaticamente da instalação do Helm, da orquestração do cluster Kubernetes (K3s), da implantação do MultiJuicer, das configurações de roteamento do Ingress e da extração das credenciais de administrador. Ao final, o terminal exibirá o IP de acesso para os participantes e a senha do painel de administração.

## Solução de Problemas (Troubleshooting)

Se o script falhar ou o ambiente não for implantado corretamente devido a conflitos no sistema local, você pode depurar o processo manualmente.

O script está estruturado de forma sequencial. Em caso de erros:

1. Abra o arquivo `setup-ctf-up.sh` em um editor de texto (como Nano ou VS Code).
2. Copie os comandos e execute-os um por um diretamente no seu terminal.
3. Essa execução manual permitirá que você identifique exatamente qual estágio (rede, Kubernetes ou Helm) está falhando e analise os logs de erro específicos.