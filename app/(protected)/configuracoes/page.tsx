import { Card } from '@/components/ui/card';

export default function ConfiguracoesPage() {
  return (
    <div className="space-y-4">
      <Card>
        <h3 className="mb-2 text-lg font-semibold">Configurações</h3>
        <p className="text-sm text-zinc-300">A senha de acesso é definida em APP_PASSWORD no ambiente.</p>
        <p className="text-sm text-zinc-400">Para produção na Vercel: Project Settings → Environment Variables → APP_PASSWORD.</p>
      </Card>
      <Card>
        <h3 className="mb-2 text-lg font-semibold">Preparação para banco de dados</h3>
        <p className="text-sm text-zinc-400">A persistência atual está em hooks/use-local-storage.ts. A troca para API/DB pode manter os mesmos tipos em types/finance.ts e funções em lib/finance.ts.</p>
      </Card>
    </div>
  );
}
