# Penpot template — Heaven Streaming

Plugin do Penpot que gera um UI kit de streaming completo, já com os tokens de
`design/tokens/tokens.json`:

| Página | Conteúdo |
|---|---|
| 00 · Cover | Capa do arquivo |
| 01 · Design System | Cores, tipografia (Inter), espaçamento, raios, ícones |
| 02 · Components | Componentes principais: Button (Primary/Secondary/Outline/Icon), Chip, Badge, Card/Poster, Card/Continue, Row/Episode, Input/Search |
| 03 · Desktop / TV | 1920×1080: Splash, Profiles, Home (scroll), Details movie, Details series, Search, Player, My List, Loading, Error, Empty |
| 04 · Mobile | 390×844: Splash, Home, Details, Search, My List, Player (paisagem) |

Também cria a biblioteca local de cores (semantic + primitives) e de tipografias,
além dos fluxos de protótipo "Desktop flow" e "Mobile flow".

## Como usar

1. Suba o servidor local (deixe-o rodando):
   ```bash
   cd design/penpot-template
   python3 serve.py
   ```
2. Abra https://design.penpot.app (Chrome, Edge ou Firefox) e crie um **arquivo novo e vazio**.
3. Abra o gerenciador de plugins: **Ctrl+Alt+P**, ou menu principal → *Plugins* → *Plugins manager*.
4. Cole `http://localhost:4400/manifest.json` e clique em **Install**. Aceite as permissões.
   Se o navegador estiver em outra máquina da rede, use o IP da máquina que roda o `serve.py`,
   por exemplo `http://192.168.1.50:4400/manifest.json`.
5. Abra o plugin **Heaven Streaming Template** e clique em **Generate template**.
   Leva de 10 a 30 segundos. O log mostra o progresso.
6. Opcional: importe os tokens no painel **Tokens** (ícone na barra lateral esquerda) →
   *Tools* → *Import* → `design/tokens/tokens.json`.

Depois que o arquivo for gerado, o plugin e o servidor não são mais necessários.
Para testar o protótipo, abra a página Desktop ou Mobile e aperte **Play** (canto superior direito).

## Solução de problemas

- **"Plugin not found" / erro ao instalar**: confira se o `serve.py` ainda está rodando e abra
  `http://localhost:4400/manifest.json` no navegador para testar.
- **Bloqueio de conteúdo misto ou rede privada no Brave/Safari**: use Chrome ou Firefox.
  Outra saída é publicar a pasta por HTTPS (GitHub Pages, por exemplo) e instalar pela URL
  `https://…/manifest.json`.
- **Algo saiu errado no meio**: avisos aparecem em amarelo no log, e o restante é gerado mesmo assim.
  Para recomeçar, apague o arquivo e rode de novo em um arquivo vazio.
