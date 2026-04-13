import { Header } from '@/components/layout/header';
import { Sidebar } from '@/components/layout/sidebar';
import { FinanceProvider } from '@/hooks/use-finance-store';

export default function ProtectedLayout({ children }: { children: React.ReactNode }) {
  return (
    <FinanceProvider>
      <div className="min-h-screen md:flex">
        <Sidebar />
        <main className="flex-1 p-4 md:p-6">
          <Header />
          {children}
        </main>
      </div>
    </FinanceProvider>
  );
}
