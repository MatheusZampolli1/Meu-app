# Finance Pro — Finanças Pessoais (Next.js 14)

Aplicação web moderna de finanças pessoais com foco em **gastos e investimentos**, pronta para GitHub e deploy na Vercel.

## Visão geral

O Finance Pro oferece:

- Login simples por senha usando variável de ambiente (`APP_PASSWORD`)
- Dashboard com indicadores e gráficos
- Gestão de lançamentos em formato de planilha
- Cadastro de investimentos
- Relatórios mensais e anuais
- Persistência local com `localStorage`
- Arquitetura preparada para evoluir para banco de dados

## Tecnologias usadas

- Next.js 14+ (App Router)
- TypeScript
- Tailwind CSS
- Componentes estilo shadcn/ui
- Recharts
- Lucide React
- PapaParse (CSV)

## Estrutura do projeto

```bash
app/
components/
data/
hooks/
lib/
types/
middleware.ts
```

## Como instalar

```bash
npm install
```

## Como rodar localmente

1. Copie o arquivo de exemplo de ambiente:

```bash
cp .env.example .env.local
```

2. Ajuste a senha no `.env.local`:

```env
APP_PASSWORD=Zampolli2025@
```

3. Rode em desenvolvimento:

```bash
npm run dev
```

4. Acesse:

```bash
http://localhost:3000
```

## Como funciona a senha por variável de ambiente

- A senha **não fica hardcoded em tela ou componente**.
- A validação ocorre no endpoint `app/api/auth/login/route.ts` usando `process.env.APP_PASSWORD`.
- O login cria cookie HTTP-only e o `middleware.ts` protege as rotas privadas.

## Como publicar na Vercel

1. Faça push para o GitHub.
2. Entre na Vercel e clique em **Add New → Project**.
3. Importe o repositório.
4. Antes de deployar, vá em:
   - **Project Settings → Environment Variables**
5. Crie:
   - **Name**: `APP_PASSWORD`
   - **Value**: sua senha
   - **Environment**: Production (e Preview/Development se desejar)
6. Clique em Deploy.

## Como conectar ao GitHub

```bash
git init
git add .
git commit -m "feat: personal finance dashboard app"
git branch -M main
git remote add origin https://github.com/SEU-USUARIO/SEU-REPO.git
git push -u origin main
```

## Scripts

```bash
npm run dev
npm run build
npm run start
npm run lint
npm run typecheck
```

## Possíveis melhorias futuras

- Backend com PostgreSQL + Prisma
- Usuários múltiplos e autenticação robusta
- Integração com Open Finance
- Metas por categoria com alertas
- Importação OFX/Excel
