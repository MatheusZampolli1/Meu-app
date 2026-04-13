'use client';

import Papa from 'papaparse';
import { Card } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { useFinanceStore } from '@/hooks/use-finance-store';
import { groupByMonth, groupExpensesByCategory, toCurrency } from '@/lib/finance';

export default function RelatoriosPage() {
  const { entries, investments, loaded } = useFinanceStore();
  if (!loaded) return <p>Carregando...</p>;

  const monthly = groupByMonth(entries);
  const expenses = groupExpensesByCategory(entries).sort((a, b) => b.value - a.value);
  const annual = entries.reduce<Record<string, number>>((acc, entry) => {
    const year = entry.date.slice(0, 4);
    acc[year] = (acc[year] ?? 0) + (entry.type === 'gasto' ? -entry.value : entry.value);
    return acc;
  }, {});

  const investmentsProgress = investments.reduce((acc, item) => acc + item.investedValue, 0);

  function exportData() {
    const csv = Papa.unparse(entries);
    const blob = new Blob([csv], { type: 'text/csv;charset=utf-8;' });
    const link = document.createElement('a');
    link.href = URL.createObjectURL(blob);
    link.setAttribute('download', 'relatorio-financeiro.csv');
    link.click();
  }

  return (
    <div className="grid gap-4 md:grid-cols-2">
      <Card>
        <h3 className="mb-3 font-semibold">Resumo mensal</h3>
        {monthly.map((item) => (
          <p key={item.month} className="text-sm">{item.month}: {toCurrency(item.receitas - item.gastos)}</p>
        ))}
      </Card>

      <Card>
        <h3 className="mb-3 font-semibold">Resumo anual</h3>
        {Object.entries(annual).map(([year, value]) => (
          <p key={year} className="text-sm">{year}: {toCurrency(value)}</p>
        ))}
      </Card>

      <Card>
        <h3 className="mb-3 font-semibold">Categorias com maior gasto</h3>
        {expenses.slice(0, 5).map((item) => (
          <p key={item.name} className="text-sm">{item.name}: {toCurrency(item.value)}</p>
        ))}
      </Card>

      <Card>
        <h3 className="mb-3 font-semibold">Evolução dos investimentos</h3>
        <p className="text-sm">Valor acumulado em aportes: {toCurrency(investmentsProgress)}</p>
        <Button className="mt-4" onClick={exportData}>Exportar dados</Button>
      </Card>
    </div>
  );
}
