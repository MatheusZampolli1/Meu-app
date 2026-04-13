'use client';

import { LogOut } from 'lucide-react';
import { useRouter } from 'next/navigation';
import { Button } from '@/components/ui/button';

export function Header() {
  const router = useRouter();

  async function logout() {
    await fetch('/api/auth/logout', { method: 'POST' });
    router.push('/login');
  }

  return (
    <header className="mb-6 flex items-center justify-between">
      <div>
        <p className="text-xs uppercase tracking-wide text-zinc-400">Painel financeiro pessoal</p>
        <h2 className="text-2xl font-bold">Visão geral</h2>
      </div>
      <Button variant="secondary" onClick={logout}>
        <LogOut className="mr-2 h-4 w-4" />
        Sair
      </Button>
    </header>
  );
}
