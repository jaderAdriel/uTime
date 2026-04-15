# Aplicativo Mobile Score News

Curso Superior de Tecnologia em Análise e Desenvolvimento de Sistemas  
Disciplina: Laboratório de Programação para Dispositivos Móveis e Sem Fio  
Professor: Welison de Brito dos Santos Batista  
Aluno: Jader Adriel Miranda Souza
Semestre: 5º  
Instituto Federal Baiano — Campus Guanambi  
Ano: 2025  

---

## SUMÁRIO

1. Proposta do Aplicativo  
2. Principais Funcionalidades  
3. Arquitetura do Sistema  
4. Telas do Aplicativo  
5. Navegação  
6. Gerenciamento de Estado  
7. APIs Utilizadas  
8. Repositório Git  
9. Considerações Finais  

---

## 1. PROPOSTA DO APLICATIVO

O aplicativo Score News tem como objetivo fornecer informações sobre o futebol brasileiro em um único lugar.  

O usuário escolhe seu time favorito e passa a acompanhar notícias, elenco e próximas partidas.  

A proposta é criar uma experiência personalizada e simples para o torcedor.  

---

## 2. PRINCIPAIS FUNCIONALIDADES

- Escolha do time favorito  
- Exibição de notícias em tempo real  
- Busca de notícias  
- Visualização de detalhes do time  
- Lista de jogadores  
- Próximas partidas  
- Favoritar notícias  
- Tela de configurações  

---

## 3. ARQUITETURA DO SISTEMA

O aplicativo segue uma organização em camadas:  

- Telas (interface do usuário)  
- Providers (gerenciamento de estado)  
- Services (requisições de API)  
- Models (estrutura de dados)  

Essa separação facilita a manutenção do código.  

---

## 4. TELAS DO APLICATIVO

- Splash Screen  
- Tela de seleção de time  
- Tela inicial (notícias)  
- Tela de detalhes da notícia  
- Tela de detalhes do time  
- Tela de favoritos  
- Tela de configurações  

---

## 5. NAVEGAÇÃO

A navegação é feita com rotas nomeadas usando go_router.  

Principais fluxos:  

- Primeiro acesso → escolha do time  
- Após escolha → tela inicial  
- Clique em notícia → tela de detalhe  
- Menu inferior → navegação entre telas  

---

## 6. GERENCIAMENTO DE ESTADO

O gerenciamento de estado é feito com Provider.  

Principais estados controlados:  

- Time selecionado  
- Lista de notícias  
- Favoritos  
- Dados do time  

---

## 7. APIs UTILIZADAS

- Football-Data API → dados dos times e partidas  
- NewsAPI → notícias  
- ESPN API → notícias adicionais  

As APIs são consumidas via HTTP.  

---

## 8. REPOSITÓRIO GIT

O projeto está versionado utilizando Git e hospedado no GitHub.  

Branch principal: main  

---

## 9. CONSIDERAÇÕES FINAIS

O aplicativo atende aos requisitos do trabalho:  

- Possui múltiplas telas  
- Utiliza navegação com rotas  
- Consome APIs  
- Usa gerenciamento de estado  
- Possui organização de código  

O projeto entrega uma solução funcional e organizada para acompanhamento do futebol.
