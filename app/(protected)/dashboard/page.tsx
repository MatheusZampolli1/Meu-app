'use client';

import { DashboardCharts } from '@/components/charts/dashboard-charts';
import { MetricsCards } from '@/components/dashboard/metrics-cards';
import { Card } from '@/components/ui/card';
import { useFinanceStore } from '@/hooks/use-finance-store';
import { calcMetrics, groupByMonth, groupExpensesByCategory, investmentAllocation, toCurrency } from '@/lib/finance';

export default function DashboardPage() {
  const { entries, investments, loaded } = useFinanceStore();
  if (!loaded) return <p>Carregando...</p>;

  const metrics = calcMetrics(entries, investments);
  const expenseData = groupExpensesByCategory(entries);
  const monthData = groupByMonth(entries);
  const allocationData = investmentAllocation(investments);

  const meta = 5000;
  const progresso = Math.min((metrics.saldo / meta) * 100, 100);

  return (
    <div className="space-y-4">
      <MetricsCards {...metrics} />
      <Card>
        <p className="mb-2 text-sm font-medium">Meta financeira mensal</p>
        <div className="h-3 w-full rounded-full bg-muted">
          <div className="h-3 rounded-full bg-accent" style={{ width: `${Math.max(0, progresso)}%` }} />
        </div>
        <p className="mt-2 text-sm text-zinc-400">
          {toCurrency(metrics.saldo)} de {toCurrency(meta)} ({progresso.toFixed(1)}%)
        </p>
      </Card>
      <DashboardCharts expenseData={expenseData} monthData={monthData} allocationData={allocationData} />
    </div>
  );
}
