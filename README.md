# CorrijAI Frontend

Bem-vindo ao repositório do **CorrijAI Frontend**, a interface de usuário para o sistema **CorrijAI**, uma aplicação moderna e eficiente que utiliza inteligência artificial para corrigir textos, fornecer feedback e melhorar a escrita. Este projeto foi desenvolvido com foco em usabilidade, performance e escalabilidade.

---

## 📋 Índice

- [Sobre o Projeto](#sobre-o-projeto)
- [Funcionalidades](#funcionalidades)
- [Estrutura do Projeto](#estrutura-do-projeto)
- [Tecnologias Utilizadas](#tecnologias-utilizadas)
- [Pré-requisitos](#pré-requisitos)
- [Instalação e Configuração](#instalação-e-configuração)
- [Como Usar](#como-usar)
- [Contribuição](#contribuição)
- [Licença](#licença)

---

## 🧐 Sobre o Projeto

O **CorrijAI Frontend** é a interface gráfica que permite aos usuários interagir com o sistema **CorrijAI**. Ele foi projetado para ser intuitivo, responsivo e acessível, garantindo uma experiência de usuário agradável em qualquer dispositivo.

O objetivo principal do projeto é permitir que os usuários insiram textos, recebam correções e sugestões baseadas em inteligência artificial, e visualizem os resultados de forma clara e organizada.

---

## ✨ Funcionalidades

- **Correção de Textos**: Envie textos para análise e receba correções detalhadas.
- **Sugestões de Melhorias**: Receba feedback sobre gramática, ortografia e estilo.
- **Interface Responsiva**: Totalmente adaptado para dispositivos móveis, tablets e desktops.
- **Histórico de Correções**: Acompanhe as correções realizadas anteriormente.
- **Integração com API**: Comunicação eficiente com o backend para processamento de textos.

---

## 🗂️ Estrutura do Projeto

A estrutura do projeto foi organizada para facilitar a manutenção e escalabilidade. Abaixo está uma visão geral dos diretórios e arquivos principais:

```
CorrijAI-frontend/
├── public/               # Arquivos públicos (HTML, ícones, etc.)
├── src/
│   ├── assets/           # Imagens, fontes e outros recursos estáticos
│   ├── components/       # Componentes reutilizáveis da interface
│   ├── pages/            # Páginas principais da aplicação
│   ├── services/         # Serviços para comunicação com a API
│   ├── styles/           # Estilos globais e específicos
│   ├── utils/            # Funções utilitárias
│   └── App.jsx           # Componente principal da aplicação
├── .env                  # Variáveis de ambiente
├── package.json          # Dependências e scripts do projeto
└── README.md             # Documentação do projeto
```

---

## 🛠️ Tecnologias Utilizadas

Este projeto foi desenvolvido utilizando as seguintes tecnologias e ferramentas:

- **React.js**: Biblioteca JavaScript para construção de interfaces de usuário.
- **Axios**: Para realizar requisições HTTP à API.
- **React Router**: Gerenciamento de rotas na aplicação.
- **CSS Modules**: Estilização modular e reutilizável.
- **ESLint e Prettier**: Para manter a qualidade e padronização do código.
- **Vite**: Ferramenta de build rápida para desenvolvimento em React.

---

## ✅ Pré-requisitos

Antes de começar, certifique-se de ter as seguintes ferramentas instaladas em sua máquina:

- [Node.js](https://nodejs.org/) (versão 16 ou superior)
- [npm](https://www.npmjs.com/) ou [yarn](https://yarnpkg.com/)

---

## 🚀 Instalação e Configuração

Siga os passos abaixo para configurar o projeto localmente:

1. **Clone o repositório**:
   ```bash
   git clone https://github.com/seu-usuario/CorrijAI-frontend.git
   ```

2. **Acesse o diretório do projeto**:
   ```bash
   cd CorrijAI-frontend
   ```

3. **Instale as dependências**:
   ```bash
   npm install
   ```

4. **Configure as variáveis de ambiente**:
   Crie um arquivo `.env` na raiz do projeto e adicione as seguintes variáveis:
   ```
   REACT_APP_API_URL=http://sua-api-url.com
   ```

5. **Inicie o servidor de desenvolvimento**:
   ```bash
   npm run dev
   ```

6. **Acesse a aplicação**:
   Abra o navegador e acesse `http://localhost:3000`.

---

## 📖 Como Usar

1. Acesse a aplicação no navegador.
2. Insira o texto que deseja corrigir no campo de entrada.
3. Clique no botão "Corrigir".
4. Visualize as sugestões e correções fornecidas pela IA.
5. (Opcional) Salve o histórico de correções para consultas futuras.

---

## 🤝 Contribuição

Contribuições são sempre bem-vindas! Siga os passos abaixo para contribuir:

1. Faça um fork do projeto.
2. Crie uma branch para sua feature ou correção:
   ```bash
   git checkout -b minha-feature
   ```
3. Faça as alterações necessárias e commit:
   ```bash
   git commit -m "Descrição da minha feature"
   ```
4. Envie para o seu fork:
   ```bash
   git push origin minha-feature
   ```
5. Abra um Pull Request no repositório original.

---

## 📜 Licença

Este projeto está licenciado sob a [MIT License](LICENSE). Sinta-se à vontade para usá-lo e modificá-lo conforme necessário.

---

## 📞 Contato

Se tiver dúvidas ou sugestões, entre em contato:

- **Email**: gustavo.couty@hotmail.com
- **GitHub**: [Gustavo de Souza Coutinho](https://github.com/Gustavo-Souza-Coutinho)

---

Obrigado por conferir o **CorrijAI Frontend**! 🎉
