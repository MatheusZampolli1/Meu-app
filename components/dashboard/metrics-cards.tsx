import { Card } from '@/components/ui/card';
import { toCurrency } from '@/lib/finance';

interface MetricCardProps {
  title: string;
  value: number;
}

function MetricCard({ title, value }: MetricCardProps) {
  return (
    <Card>
      <p className="text-xs uppercase tracking-wide text-zinc-400">{title}</p>
      <p className="mt-2 text-2xl font-semibold">{toCurrency(value)}</p>
    </Card>
  );
}

export function MetricsCards({
  receitas,
  gastos,
  saldo,
  totalInvestido,
  patrimonio,
  rentabilidade
}: {
  receitas: number;
  gastos: number;
  saldo: number;
  totalInvestido: number;
  patrimonio: number;
  rentabilidade: number;
}) {
  return (
    <section className="grid gap-4 sm:grid-cols-2 xl:grid-cols-3">
      <MetricCard title="Total de receitas" value={receitas} />
      <MetricCard title="Total de gastos" value={gastos} />
      <MetricCard title="Saldo do mês" value={saldo} />
      <MetricCard title="Total investido" value={totalInvestido} />
      <MetricCard title="Patrimônio acumulado" value={patrimonio} />
      <MetricCard title="Rentabilidade simulada" value={rentabilidade} />
    </section>
  );
}
