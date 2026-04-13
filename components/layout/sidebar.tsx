'use client';

import Link from 'next/link';
import { usePathname } from 'next/navigation';
import { BarChart3, Cog, Landmark, LayoutDashboard, PiggyBank } from 'lucide-react';
import { cn } from '@/lib/utils';

const items = [
  { href: '/dashboard', label: 'Dashboard', icon: LayoutDashboard },
  { href: '/lancamentos', label: 'Lançamentos', icon: Landmark },
  { href: '/investimentos', label: 'Investimentos', icon: PiggyBank },
  { href: '/relatorios', label: 'Relatórios', icon: BarChart3 },
  { href: '/configuracoes', label: 'Configurações', icon: Cog }
];

export function Sidebar() {
  const pathname = usePathname();

  return (
    <aside className="w-full border-b border-border p-4 md:w-64 md:border-b-0 md:border-r">
      <h1 className="mb-6 text-lg font-semibold">Finance Pro</h1>
      <nav className="flex flex-wrap gap-2 md:flex-col">
        {items.map((item) => {
          const Icon = item.icon;
          return (
            <Link
              key={item.href}
              href={item.href}
              className={cn(
                'flex items-center gap-2 rounded-md px-3 py-2 text-sm transition-colors',
                pathname === item.href ? 'bg-accent text-black' : 'hover:bg-muted'
              )}
            >
              <Icon size={16} />
              {item.label}
            </Link>
          );
        })}
      </nav>
    </aside>
  );
}
