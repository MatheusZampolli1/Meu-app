import { FinancialEntry, Investment } from '@/types/finance';

export function toCurrency(value: number) {
  return new Intl.NumberFormat('pt-BR', { style: 'currency', currency: 'BRL' }).format(value);
}

export function calcMetrics(entries: FinancialEntry[], investments: Investment[]) {
  const receitas = entries.filter((e) => e.type === 'receita').reduce((acc, e) => acc + e.value, 0);
  const gastos = entries.filter((e) => e.type === 'gasto').reduce((acc, e) => acc + e.value, 0);
  const totalInvestido = investments.reduce((acc, i) => acc + i.investedValue, 0);
  const patrimonio = receitas - gastos + totalInvestido;
  const rentabilidade = totalInvestido * 0.012;

  return {
    receitas,
    gastos,
    saldo: receitas - gastos,
    totalInvestido,
    patrimonio,
    rentabilidade
  };
}

export function groupExpensesByCategory(entries: FinancialEntry[]) {
  const map = new Map<string, number>();
  entries
    .filter((e) => e.type === 'gasto')
    .forEach((entry) => map.set(entry.category, (map.get(entry.category) ?? 0) + entry.value));

  return Array.from(map.entries()).map(([name, value]) => ({ name, value }));
}

export function groupByMonth(entries: FinancialEntry[]) {
  const map = new Map<string, { receitas: number; gastos: number }>();
  entries.forEach((entry) => {
    const month = entry.date.slice(0, 7);
    const current = map.get(month) ?? { receitas: 0, gastos: 0 };
    if (entry.type === 'receita') current.receitas += entry.value;
    if (entry.type === 'gasto') current.gastos += entry.value;
    map.set(month, current);
  });

  return Array.from(map.entries())
    .sort((a, b) => a[0].localeCompare(b[0]))
    .map(([month, values]) => ({ month, ...values, patrimonio: values.receitas - values.gastos }));
}

export function investmentAllocation(investments: Investment[]) {
  const map = new Map<string, number>();
  investments.forEach((item) => map.set(item.assetType, (map.get(item.assetType) ?? 0) + item.investedValue));
  return Array.from(map.entries()).map(([name, value]) => ({ name, value }));
}
